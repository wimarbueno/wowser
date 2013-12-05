module.exports = (grunt) ->

  # Wowser configuration
  grunt.initConfig {
    pkg: grunt.file.readJSON('package.json'),

    # Metadata
    meta: {
      banner: '/**\n' +
              ' * Wowser v<%= pkg.version %>\n' +
              ' * Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.name %> <<%= pkg.homepage %>>\n' +
              ' *\n' +
              ' * World of Warcraft in the browser using JavaScript and WebGL.\n' +
              ' *\n' +
              ' * The contents of this file are subject to the MIT License, under which\n' +
              ' * this library is licensed. See the LICENSE file for the full license.\n' +
              ' */\n\n'
    },

    # Compiles CoffeeScript source
    coffee: {
      dist: {
        expand: true,
        cwd: 'src',
        src: '**/*.coffee',
        dest: 'build',
        ext: '.js',
        options: {
          bare: true
        }
      }
    },

    # Concatenate compiled JavaScript files
    # Note: Order is significant due to namespacing
    concat: {
      dist: {
        options: {
          banner: '<%= meta.banner %>'
        }
        src: [
          'build/wowser.js',
          'build/wowser/utils/**/*.js',
          'vendor/byte-buffer.js',
          'vendor/jsbn.js',
          'vendor/underscore.js',
          'vendor/backbone.js',
          'build/wowser/crypto/hash/**/*.js',
          'build/wowser/crypto/**/*.js',
          'build/wowser/datastructures/**/*.js',
          'build/wowser/net/**/*.js',
          'build/wowser/entities/**/*.js',
          'build/wowser/expansions/expansion.js',
          'build/wowser/expansions/wotlk/wotlk.js',
          'build/wowser/expansions/wotlk/enums/**/*.js',
          'build/wowser/expansions/wotlk/net/**/*.js',
          'build/wowser/expansions/wotlk/**/*.js',
          'build/wowser/sessions/**/*.js'
        ],
        dest: 'dist/<%= pkg.name %>.js'
      }
    },

    # Lints project files using JSHint
    jshint: {
      options: {
        boss: true,
        eqnull: true,
        shadow: true
      },
      files: [
        'build/**/*.js'
      ]
    },

    # Minified distribution
    uglify: {
      dist: {
        options: {
          banner: '<%= meta.banner %>'
        },
        files: {
          'dist/<%= pkg.name %>.min.js': ['<%= concat.dist.dest %>']
        }
      }
    },

    # Watch for changes to source and vendor files
    watch: {
      files: [
        'Gruntfile.coffee',
        'src/**/*.coffee',
        'vendor/**/*.js'
      ],
      tasks: ['build']
    }
  }

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-jshint'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'default', ['watch']
  grunt.registerTask 'build',   ['coffee', 'jshint', 'concat']
  grunt.registerTask 'release', ['build', 'uglify']