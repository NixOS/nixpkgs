{buildNodePackage, fetchurl, fetchgit, self}:

let
  registry = {
    "titanium-5.0.5" = buildNodePackage {
      name = "titanium";
      version = "5.0.5";
      src = fetchurl {
        url = "http://registry.npmjs.org/titanium/-/titanium-5.0.5.tgz";
        sha1 = "38a466deaeee9a8b346973d70a8baaeb4c3af281";
      };
      dependencies = {
        async = {
          "1.4.2" = {
            version = "1.4.2";
            pkg = self."async-1.4.2";
          };
        };
        colors = {
          "1.1.2" = {
            version = "1.1.2";
            pkg = self."colors-1.1.2";
          };
        };
        fields = {
          "0.1.24" = {
            version = "0.1.24";
            pkg = self."fields-0.1.24";
          };
        };
        humanize = {
          "0.0.9" = {
            version = "0.0.9";
            pkg = self."humanize-0.0.9";
          };
        };
        longjohn = {
          "0.2.9" = {
            version = "0.2.9";
            pkg = self."longjohn-0.2.9";
          };
        };
        moment = {
          "2.10.6" = {
            version = "2.10.6";
            pkg = self."moment-2.10.6";
          };
        };
        node-appc = {
          "0.2.31" = {
            version = "0.2.31";
            pkg = self."node-appc-0.2.31";
          };
        };
        request = {
          "2.62.0" = {
            version = "2.62.0";
            pkg = self."request-2.62.0";
          };
        };
        semver = {
          "5.0.3" = {
            version = "5.0.3";
            pkg = self."semver-5.0.3";
          };
        };
        sprintf = {
          "0.1.5" = {
            version = "0.1.5";
            pkg = self."sprintf-0.1.5";
          };
        };
        temp = {
          "0.8.3" = {
            version = "0.8.3";
            pkg = self."temp-0.8.3";
          };
        };
        winston = {
          "1.0.x" = {
            version = "1.0.2";
            pkg = self."winston-1.0.2";
          };
        };
        wrench = {
          "1.5.8" = {
            version = "1.5.8";
            pkg = self."wrench-1.5.8";
          };
        };
      };
      meta = {
        description = "Appcelerator Titanium Command line";
        homepage = "https://github.com/appcelerator/titanium#readme";
        license = "Apache-2.0";
      };
      production = true;
      linkDependencies = false;
    };
    "async-1.4.2" = buildNodePackage {
      name = "async";
      version = "1.4.2";
      src = fetchurl {
        url = "http://registry.npmjs.org/async/-/async-1.4.2.tgz";
        sha1 = "6c9edcb11ced4f0dd2f2d40db0d49a109c088aab";
      };
      meta = {
        description = "Higher-order functions and common patterns for asynchronous code";
        homepage = "https://github.com/caolan/async#readme";
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "colors-1.1.2" = buildNodePackage {
      name = "colors";
      version = "1.1.2";
      src = fetchurl {
        url = "http://registry.npmjs.org/colors/-/colors-1.1.2.tgz";
        sha1 = "168a4701756b6a7f51a12ce0c97bfa28c084ed63";
      };
      meta = {
        description = "get colors in your node.js console";
        homepage = https://github.com/Marak/colors.js;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "fields-0.1.24" = buildNodePackage {
      name = "fields";
      version = "0.1.24";
      src = fetchurl {
        url = "http://registry.npmjs.org/fields/-/fields-0.1.24.tgz";
        sha1 = "bed93b1c2521f4705fe764f4209267fdfd89f5d3";
      };
      dependencies = {
        colors = {
          "~0.6.2" = {
            version = "0.6.2";
            pkg = self."colors-0.6.2";
          };
        };
        keypress = {
          "~0.2.1" = {
            version = "0.2.1";
            pkg = self."keypress-0.2.1";
          };
        };
        sprintf = {
          "~0.1.4" = {
            version = "0.1.5";
            pkg = self."sprintf-0.1.5";
          };
        };
      };
      meta = {
        description = "Creates fields to prompt for input at the command line";
        homepage = https://github.com/cb1kenobi/fields;
      };
      production = true;
      linkDependencies = false;
    };
    "colors-0.6.2" = buildNodePackage {
      name = "colors";
      version = "0.6.2";
      src = fetchurl {
        url = "http://registry.npmjs.org/colors/-/colors-0.6.2.tgz";
        sha1 = "2423fe6678ac0c5dae8852e5d0e5be08c997abcc";
      };
      meta = {
        description = "get colors in your node.js console like what";
        homepage = https://github.com/Marak/colors.js;
      };
      production = true;
      linkDependencies = false;
    };
    "colors-~0.6.2" = self."colors-0.6.2";
    "keypress-0.2.1" = buildNodePackage {
      name = "keypress";
      version = "0.2.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/keypress/-/keypress-0.2.1.tgz";
        sha1 = "1e80454250018dbad4c3fe94497d6e67b6269c77";
      };
      meta = {
        description = "Make any Node ReadableStream emit \"keypress\" events";
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "keypress-~0.2.1" = self."keypress-0.2.1";
    "sprintf-0.1.5" = buildNodePackage {
      name = "sprintf";
      version = "0.1.5";
      src = fetchurl {
        url = "http://registry.npmjs.org/sprintf/-/sprintf-0.1.5.tgz";
        sha1 = "8f83e39a9317c1a502cb7db8050e51c679f6edcf";
      };
      meta = {
        description = "Sprintf() for node.js";
        homepage = https://github.com/maritz/node-sprintf;
        license = "BSD-3-Clause";
      };
      production = true;
      linkDependencies = false;
    };
    "sprintf-~0.1.4" = self."sprintf-0.1.5";
    "humanize-0.0.9" = buildNodePackage {
      name = "humanize";
      version = "0.0.9";
      src = fetchurl {
        url = "http://registry.npmjs.org/humanize/-/humanize-0.0.9.tgz";
        sha1 = "1994ffaecdfe9c441ed2bdac7452b7bb4c9e41a4";
      };
      dependencies = {};
      meta = {
        description = "Javascript string formatter for human readability";
        homepage = https://github.com/taijinlee/humanize;
      };
      production = true;
      linkDependencies = false;
    };
    "longjohn-0.2.9" = buildNodePackage {
      name = "longjohn";
      version = "0.2.9";
      src = fetchurl {
        url = "http://registry.npmjs.org/longjohn/-/longjohn-0.2.9.tgz";
        sha1 = "db1bf175fcfffcfce099132d1470f52f41a31519";
      };
      dependencies = {
        source-map-support = {
          "0.3.2" = {
            version = "0.3.2";
            pkg = self."source-map-support-0.3.2";
          };
        };
      };
      meta = {
        description = "Long stack traces for node.js inspired by https://github.com/tlrobinson/long-stack-traces";
        homepage = https://github.com/mattinsler/longjohn;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "source-map-support-0.3.2" = buildNodePackage {
      name = "source-map-support";
      version = "0.3.2";
      src = fetchurl {
        url = "http://registry.npmjs.org/source-map-support/-/source-map-support-0.3.2.tgz";
        sha1 = "737d5c901e0b78fdb53aca713d24f23ccbb10be1";
      };
      dependencies = {
        source-map = {
          "0.1.32" = {
            version = "0.1.32";
            pkg = self."source-map-0.1.32";
          };
        };
      };
      meta = {
        description = "Fixes stack traces for files with source maps";
        homepage = https://github.com/evanw/node-source-map-support;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "source-map-0.1.32" = buildNodePackage {
      name = "source-map";
      version = "0.1.32";
      src = fetchurl {
        url = "http://registry.npmjs.org/source-map/-/source-map-0.1.32.tgz";
        sha1 = "c8b6c167797ba4740a8ea33252162ff08591b266";
      };
      dependencies = {
        amdefine = {
          ">=0.0.4" = {
            version = "1.0.0";
            pkg = self."amdefine-1.0.0";
          };
        };
      };
      meta = {
        description = "Generates and consumes source maps";
        homepage = https://github.com/mozilla/source-map;
      };
      production = true;
      linkDependencies = false;
    };
    "amdefine-1.0.0" = buildNodePackage {
      name = "amdefine";
      version = "1.0.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/amdefine/-/amdefine-1.0.0.tgz";
        sha1 = "fd17474700cb5cc9c2b709f0be9d23ce3c198c33";
      };
      meta = {
        description = "Provide AMD's define() API for declaring modules in the AMD format";
        homepage = http://github.com/jrburke/amdefine;
        license = "BSD-3-Clause AND MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "amdefine->=0.0.4" = self."amdefine-1.0.0";
    "moment-2.10.6" = buildNodePackage {
      name = "moment";
      version = "2.10.6";
      src = fetchurl {
        url = "http://registry.npmjs.org/moment/-/moment-2.10.6.tgz";
        sha1 = "6cb21967c79cba7b0ca5e66644f173662b3efa77";
      };
      meta = {
        description = "Parse, validate, manipulate, and display dates";
        homepage = http://momentjs.com/;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "node-appc-0.2.31" = buildNodePackage {
      name = "node-appc";
      version = "0.2.31";
      src = fetchurl {
        url = "http://registry.npmjs.org/node-appc/-/node-appc-0.2.31.tgz";
        sha1 = "8d8d0052fd8b8ce4bc44f06883009f7c950bc8c2";
      };
      dependencies = {
        adm-zip = {
          "0.4.7" = {
            version = "0.4.7";
            pkg = self."adm-zip-0.4.7";
          };
        };
        async = {
          "1.4.2" = {
            version = "1.4.2";
            pkg = self."async-1.4.2";
          };
        };
        colors = {
          "1.1.2" = {
            version = "1.1.2";
            pkg = self."colors-1.1.2";
          };
        };
        diff = {
          "2.1.0" = {
            version = "2.1.0";
            pkg = self."diff-2.1.0";
          };
        };
        node-uuid = {
          "1.4.3" = {
            version = "1.4.3";
            pkg = self."node-uuid-1.4.3";
          };
        };
        optimist = {
          "0.6.1" = {
            version = "0.6.1";
            pkg = self."optimist-0.6.1";
          };
        };
        request = {
          "2.61.0" = {
            version = "2.61.0";
            pkg = self."request-2.61.0";
          };
        };
        semver = {
          "5.0.1" = {
            version = "5.0.1";
            pkg = self."semver-5.0.1";
          };
        };
        sprintf = {
          "0.1.5" = {
            version = "0.1.5";
            pkg = self."sprintf-0.1.5";
          };
        };
        temp = {
          "0.8.3" = {
            version = "0.8.3";
            pkg = self."temp-0.8.3";
          };
        };
        wrench = {
          "1.5.8" = {
            version = "1.5.8";
            pkg = self."wrench-1.5.8";
          };
        };
        uglify-js = {
          "2.4.24" = {
            version = "2.4.24";
            pkg = self."uglify-js-2.4.24";
          };
        };
        xmldom = {
          "0.1.19" = {
            version = "0.1.19";
            pkg = self."xmldom-0.1.19";
          };
        };
      };
      meta = {
        description = "Appcelerator Common Node Library";
        homepage = http://github.com/appcelerator/node-appc;
        license = "Apache Public License v2";
      };
      production = true;
      linkDependencies = false;
    };
    "adm-zip-0.4.7" = buildNodePackage {
      name = "adm-zip";
      version = "0.4.7";
      src = fetchurl {
        url = "http://registry.npmjs.org/adm-zip/-/adm-zip-0.4.7.tgz";
        sha1 = "8606c2cbf1c426ce8c8ec00174447fd49b6eafc1";
      };
      meta = {
        description = "A Javascript implementation of zip for nodejs. Allows user to create or extract zip files both in memory or to/from disk";
        homepage = http://github.com/cthackers/adm-zip;
      };
      production = true;
      linkDependencies = false;
    };
    "diff-2.1.0" = buildNodePackage {
      name = "diff";
      version = "2.1.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/diff/-/diff-2.1.0.tgz";
        sha1 = "39b5aa97f0d1600b428ad0a91dc8efcc9b29e288";
      };
      dependencies = {};
      meta = {
        description = "A javascript text diff implementation";
        homepage = "https://github.com/kpdecker/jsdiff#readme";
        license = "BSD-3-Clause";
      };
      production = true;
      linkDependencies = false;
    };
    "node-uuid-1.4.3" = buildNodePackage {
      name = "node-uuid";
      version = "1.4.3";
      src = fetchurl {
        url = "http://registry.npmjs.org/node-uuid/-/node-uuid-1.4.3.tgz";
        sha1 = "319bb7a56e7cb63f00b5c0cd7851cd4b4ddf1df9";
      };
      meta = {
        description = "Rigorous implementation of RFC4122 (v1 and v4) UUIDs";
        homepage = https://github.com/broofa/node-uuid;
      };
      production = true;
      linkDependencies = false;
    };
    "optimist-0.6.1" = buildNodePackage {
      name = "optimist";
      version = "0.6.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/optimist/-/optimist-0.6.1.tgz";
        sha1 = "da3ea74686fa21a19a111c326e90eb15a0196686";
      };
      dependencies = {
        wordwrap = {
          "~0.0.2" = {
            version = "0.0.3";
            pkg = self."wordwrap-0.0.3";
          };
        };
        minimist = {
          "~0.0.1" = {
            version = "0.0.10";
            pkg = self."minimist-0.0.10";
          };
        };
      };
      meta = {
        description = "Light-weight option parsing with an argv hash. No optstrings attached";
        homepage = https://github.com/substack/node-optimist;
        license = "MIT/X11";
      };
      production = true;
      linkDependencies = false;
    };
    "wordwrap-0.0.3" = buildNodePackage {
      name = "wordwrap";
      version = "0.0.3";
      src = fetchurl {
        url = "http://registry.npmjs.org/wordwrap/-/wordwrap-0.0.3.tgz";
        sha1 = "a3d5da6cd5c0bc0008d37234bbaf1bed63059107";
      };
      meta = {
        description = "Wrap those words. Show them at what columns to start and stop";
        homepage = "https://github.com/substack/node-wordwrap#readme";
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "wordwrap-~0.0.2" = self."wordwrap-0.0.3";
    "minimist-0.0.10" = buildNodePackage {
      name = "minimist";
      version = "0.0.10";
      src = fetchurl {
        url = "http://registry.npmjs.org/minimist/-/minimist-0.0.10.tgz";
        sha1 = "de3f98543dbf96082be48ad1a0c7cda836301dcf";
      };
      meta = {
        description = "parse argument options";
        homepage = https://github.com/substack/minimist;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "minimist-~0.0.1" = self."minimist-0.0.10";
    "request-2.61.0" = buildNodePackage {
      name = "request";
      version = "2.61.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.61.0.tgz";
        sha1 = "6973cb2ac94885f02693f554eec64481d6013f9f";
      };
      dependencies = {
        bl = {
          "~1.0.0" = {
            version = "1.0.0";
            pkg = self."bl-1.0.0";
          };
        };
        caseless = {
          "~0.11.0" = {
            version = "0.11.0";
            pkg = self."caseless-0.11.0";
          };
        };
        extend = {
          "~3.0.0" = {
            version = "3.0.0";
            pkg = self."extend-3.0.0";
          };
        };
        forever-agent = {
          "~0.6.0" = {
            version = "0.6.1";
            pkg = self."forever-agent-0.6.1";
          };
        };
        form-data = {
          "~1.0.0-rc1" = {
            version = "1.0.0-rc3";
            pkg = self."form-data-1.0.0-rc3";
          };
        };
        json-stringify-safe = {
          "~5.0.0" = {
            version = "5.0.1";
            pkg = self."json-stringify-safe-5.0.1";
          };
        };
        mime-types = {
          "~2.1.2" = {
            version = "2.1.8";
            pkg = self."mime-types-2.1.8";
          };
        };
        node-uuid = {
          "~1.4.0" = {
            version = "1.4.7";
            pkg = self."node-uuid-1.4.7";
          };
        };
        qs = {
          "~4.0.0" = {
            version = "4.0.0";
            pkg = self."qs-4.0.0";
          };
        };
        tunnel-agent = {
          "~0.4.0" = {
            version = "0.4.2";
            pkg = self."tunnel-agent-0.4.2";
          };
        };
        tough-cookie = {
          ">=0.12.0" = {
            version = "2.2.1";
            pkg = self."tough-cookie-2.2.1";
          };
        };
        http-signature = {
          "~0.11.0" = {
            version = "0.11.0";
            pkg = self."http-signature-0.11.0";
          };
        };
        oauth-sign = {
          "~0.8.0" = {
            version = "0.8.0";
            pkg = self."oauth-sign-0.8.0";
          };
        };
        hawk = {
          "~3.1.0" = {
            version = "3.1.2";
            pkg = self."hawk-3.1.2";
          };
        };
        aws-sign2 = {
          "~0.5.0" = {
            version = "0.5.0";
            pkg = self."aws-sign2-0.5.0";
          };
        };
        stringstream = {
          "~0.0.4" = {
            version = "0.0.5";
            pkg = self."stringstream-0.0.5";
          };
        };
        combined-stream = {
          "~1.0.1" = {
            version = "1.0.5";
            pkg = self."combined-stream-1.0.5";
          };
        };
        isstream = {
          "~0.1.1" = {
            version = "0.1.2";
            pkg = self."isstream-0.1.2";
          };
        };
        har-validator = {
          "^1.6.1" = {
            version = "1.8.0";
            pkg = self."har-validator-1.8.0";
          };
        };
      };
      meta = {
        description = "Simplified HTTP request client";
        homepage = "https://github.com/request/request#readme";
        license = "Apache-2.0";
      };
      production = true;
      linkDependencies = false;
    };
    "bl-1.0.0" = buildNodePackage {
      name = "bl";
      version = "1.0.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/bl/-/bl-1.0.0.tgz";
        sha1 = "ada9a8a89a6d7ac60862f7dec7db207873e0c3f5";
      };
      dependencies = {
        readable-stream = {
          "~2.0.0" = {
            version = "2.0.5";
            pkg = self."readable-stream-2.0.5";
          };
        };
      };
      meta = {
        description = "Buffer List: collect buffers and access with a standard readable Buffer interface, streamable too!";
        homepage = https://github.com/rvagg/bl;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "readable-stream-2.0.5" = buildNodePackage {
      name = "readable-stream";
      version = "2.0.5";
      src = fetchurl {
        url = "http://registry.npmjs.org/readable-stream/-/readable-stream-2.0.5.tgz";
        sha1 = "a2426f8dcd4551c77a33f96edf2886a23c829669";
      };
      dependencies = {
        core-util-is = {
          "~1.0.0" = {
            version = "1.0.2";
            pkg = self."core-util-is-1.0.2";
          };
        };
        inherits = {
          "~2.0.1" = {
            version = "2.0.1";
            pkg = self."inherits-2.0.1";
          };
        };
        isarray = {
          "0.0.1" = {
            version = "0.0.1";
            pkg = self."isarray-0.0.1";
          };
        };
        process-nextick-args = {
          "~1.0.6" = {
            version = "1.0.6";
            pkg = self."process-nextick-args-1.0.6";
          };
        };
        string_decoder = {
          "~0.10.x" = {
            version = "0.10.31";
            pkg = self."string_decoder-0.10.31";
          };
        };
        util-deprecate = {
          "~1.0.1" = {
            version = "1.0.2";
            pkg = self."util-deprecate-1.0.2";
          };
        };
      };
      meta = {
        description = "Streams3, a user-land copy of the stream library from iojs v2.x";
        homepage = "https://github.com/nodejs/readable-stream#readme";
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "core-util-is-1.0.2" = buildNodePackage {
      name = "core-util-is";
      version = "1.0.2";
      src = fetchurl {
        url = "http://registry.npmjs.org/core-util-is/-/core-util-is-1.0.2.tgz";
        sha1 = "b5fd54220aa2bc5ab57aab7140c940754503c1a7";
      };
      meta = {
        description = "The `util.is*` functions introduced in Node v0.12";
        homepage = "https://github.com/isaacs/core-util-is#readme";
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "core-util-is-~1.0.0" = self."core-util-is-1.0.2";
    "inherits-2.0.1" = buildNodePackage {
      name = "inherits";
      version = "2.0.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/inherits/-/inherits-2.0.1.tgz";
        sha1 = "b17d08d326b4423e568eff719f91b0b1cbdf69f1";
      };
      meta = {
        description = "Browser-friendly inheritance fully compatible with standard node.js inherits()";
        license = "ISC";
      };
      production = true;
      linkDependencies = false;
    };
    "inherits-~2.0.1" = self."inherits-2.0.1";
    "isarray-0.0.1" = buildNodePackage {
      name = "isarray";
      version = "0.0.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/isarray/-/isarray-0.0.1.tgz";
        sha1 = "8a18acfca9a8f4177e09abfc6038939b05d1eedf";
      };
      dependencies = {};
      meta = {
        description = "Array#isArray for older browsers";
        homepage = https://github.com/juliangruber/isarray;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "process-nextick-args-1.0.6" = buildNodePackage {
      name = "process-nextick-args";
      version = "1.0.6";
      src = fetchurl {
        url = "http://registry.npmjs.org/process-nextick-args/-/process-nextick-args-1.0.6.tgz";
        sha1 = "0f96b001cea90b12592ce566edb97ec11e69bd05";
      };
      meta = {
        description = "process.nextTick but always with args";
        homepage = https://github.com/calvinmetcalf/process-nextick-args;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "process-nextick-args-~1.0.6" = self."process-nextick-args-1.0.6";
    "string_decoder-0.10.31" = buildNodePackage {
      name = "string_decoder";
      version = "0.10.31";
      src = fetchurl {
        url = "http://registry.npmjs.org/string_decoder/-/string_decoder-0.10.31.tgz";
        sha1 = "62e203bc41766c6c28c9fc84301dab1c5310fa94";
      };
      dependencies = {};
      meta = {
        description = "The string_decoder module from Node core";
        homepage = https://github.com/rvagg/string_decoder;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "string_decoder-~0.10.x" = self."string_decoder-0.10.31";
    "util-deprecate-1.0.2" = buildNodePackage {
      name = "util-deprecate";
      version = "1.0.2";
      src = fetchurl {
        url = "http://registry.npmjs.org/util-deprecate/-/util-deprecate-1.0.2.tgz";
        sha1 = "450d4dc9fa70de732762fbd2d4a28981419a0ccf";
      };
      meta = {
        description = "The Node.js `util.deprecate()` function with browser support";
        homepage = https://github.com/TooTallNate/util-deprecate;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "util-deprecate-~1.0.1" = self."util-deprecate-1.0.2";
    "readable-stream-~2.0.0" = self."readable-stream-2.0.5";
    "bl-~1.0.0" = self."bl-1.0.0";
    "caseless-0.11.0" = buildNodePackage {
      name = "caseless";
      version = "0.11.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/caseless/-/caseless-0.11.0.tgz";
        sha1 = "715b96ea9841593cc33067923f5ec60ebda4f7d7";
      };
      meta = {
        description = "Caseless object set/get/has, very useful when working with HTTP headers";
        homepage = "https://github.com/mikeal/caseless#readme";
        license = "Apache-2.0";
      };
      production = true;
      linkDependencies = false;
    };
    "caseless-~0.11.0" = self."caseless-0.11.0";
    "extend-3.0.0" = buildNodePackage {
      name = "extend";
      version = "3.0.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/extend/-/extend-3.0.0.tgz";
        sha1 = "5a474353b9f3353ddd8176dfd37b91c83a46f1d4";
      };
      dependencies = {};
      meta = {
        description = "Port of jQuery.extend for node.js and the browser";
        homepage = "https://github.com/justmoon/node-extend#readme";
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "extend-~3.0.0" = self."extend-3.0.0";
    "forever-agent-0.6.1" = buildNodePackage {
      name = "forever-agent";
      version = "0.6.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/forever-agent/-/forever-agent-0.6.1.tgz";
        sha1 = "fbc71f0c41adeb37f96c577ad1ed42d8fdacca91";
      };
      dependencies = {};
      meta = {
        description = "HTTP Agent that keeps socket connections alive between keep-alive requests. Formerly part of mikeal/request, now a standalone module";
        homepage = https://github.com/mikeal/forever-agent;
        license = "Apache-2.0";
      };
      production = true;
      linkDependencies = false;
    };
    "forever-agent-~0.6.0" = self."forever-agent-0.6.1";
    "form-data-1.0.0-rc3" = buildNodePackage {
      name = "form-data";
      version = "1.0.0-rc3";
      src = fetchurl {
        url = "http://registry.npmjs.org/form-data/-/form-data-1.0.0-rc3.tgz";
        sha1 = "d35bc62e7fbc2937ae78f948aaa0d38d90607577";
      };
      dependencies = {
        async = {
          "^1.4.0" = {
            version = "1.5.1";
            pkg = self."async-1.5.1";
          };
        };
        combined-stream = {
          "^1.0.5" = {
            version = "1.0.5";
            pkg = self."combined-stream-1.0.5";
          };
        };
        mime-types = {
          "^2.1.3" = {
            version = "2.1.8";
            pkg = self."mime-types-2.1.8";
          };
        };
      };
      meta = {
        description = "A library to create readable \"multipart/form-data\" streams. Can be used to submit forms and file uploads to other web applications";
        homepage = "https://github.com/form-data/form-data#readme";
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "async-1.5.1" = buildNodePackage {
      name = "async";
      version = "1.5.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/async/-/async-1.5.1.tgz";
        sha1 = "b05714f4b11b357bf79adaffdd06da42d0766c10";
      };
      meta = {
        description = "Higher-order functions and common patterns for asynchronous code";
        homepage = "https://github.com/caolan/async#readme";
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "async-^1.4.0" = self."async-1.5.1";
    "combined-stream-1.0.5" = buildNodePackage {
      name = "combined-stream";
      version = "1.0.5";
      src = fetchurl {
        url = "http://registry.npmjs.org/combined-stream/-/combined-stream-1.0.5.tgz";
        sha1 = "938370a57b4a51dea2c77c15d5c5fdf895164009";
      };
      dependencies = {
        delayed-stream = {
          "~1.0.0" = {
            version = "1.0.0";
            pkg = self."delayed-stream-1.0.0";
          };
        };
      };
      meta = {
        description = "A stream that emits multiple other streams one after another";
        homepage = https://github.com/felixge/node-combined-stream;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "delayed-stream-1.0.0" = buildNodePackage {
      name = "delayed-stream";
      version = "1.0.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/delayed-stream/-/delayed-stream-1.0.0.tgz";
        sha1 = "df3ae199acadfb7d440aaae0b29e2272b24ec619";
      };
      dependencies = {};
      meta = {
        description = "Buffers events from a stream until you are ready to handle them";
        homepage = https://github.com/felixge/node-delayed-stream;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "delayed-stream-~1.0.0" = self."delayed-stream-1.0.0";
    "combined-stream-^1.0.5" = self."combined-stream-1.0.5";
    "mime-types-2.1.8" = buildNodePackage {
      name = "mime-types";
      version = "2.1.8";
      src = fetchurl {
        url = "http://registry.npmjs.org/mime-types/-/mime-types-2.1.8.tgz";
        sha1 = "faf57823de04bc7cbff4ee82c6b63946e812ae72";
      };
      dependencies = {
        mime-db = {
          "~1.20.0" = {
            version = "1.20.0";
            pkg = self."mime-db-1.20.0";
          };
        };
      };
      meta = {
        description = "The ultimate javascript content-type utility";
        homepage = https://github.com/jshttp/mime-types;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "mime-db-1.20.0" = buildNodePackage {
      name = "mime-db";
      version = "1.20.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/mime-db/-/mime-db-1.20.0.tgz";
        sha1 = "496f90fd01fe0e031c8823ec3aa9450ffda18ed8";
      };
      meta = {
        description = "Media Type Database";
        homepage = https://github.com/jshttp/mime-db;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "mime-db-~1.20.0" = self."mime-db-1.20.0";
    "mime-types-^2.1.3" = self."mime-types-2.1.8";
    "form-data-~1.0.0-rc1" = self."form-data-1.0.0-rc3";
    "json-stringify-safe-5.0.1" = buildNodePackage {
      name = "json-stringify-safe";
      version = "5.0.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/json-stringify-safe/-/json-stringify-safe-5.0.1.tgz";
        sha1 = "1296a2d58fd45f19a0f6ce01d65701e2c735b6eb";
      };
      meta = {
        description = "Like JSON.stringify, but doesn't blow up on circular refs";
        homepage = https://github.com/isaacs/json-stringify-safe;
        license = "ISC";
      };
      production = true;
      linkDependencies = false;
    };
    "json-stringify-safe-~5.0.0" = self."json-stringify-safe-5.0.1";
    "mime-types-~2.1.2" = self."mime-types-2.1.8";
    "node-uuid-1.4.7" = buildNodePackage {
      name = "node-uuid";
      version = "1.4.7";
      src = fetchurl {
        url = "http://registry.npmjs.org/node-uuid/-/node-uuid-1.4.7.tgz";
        sha1 = "6da5a17668c4b3dd59623bda11cf7fa4c1f60a6f";
      };
      dependencies = {};
      meta = {
        description = "Rigorous implementation of RFC4122 (v1 and v4) UUIDs";
        homepage = https://github.com/broofa/node-uuid;
      };
      production = true;
      linkDependencies = false;
    };
    "node-uuid-~1.4.0" = self."node-uuid-1.4.7";
    "qs-4.0.0" = buildNodePackage {
      name = "qs";
      version = "4.0.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/qs/-/qs-4.0.0.tgz";
        sha1 = "c31d9b74ec27df75e543a86c78728ed8d4623607";
      };
      dependencies = {};
      meta = {
        description = "A querystring parser that supports nesting and arrays, with a depth limit";
        homepage = https://github.com/hapijs/qs;
        license = "BSD-3-Clause";
      };
      production = true;
      linkDependencies = false;
    };
    "qs-~4.0.0" = self."qs-4.0.0";
    "tunnel-agent-0.4.2" = buildNodePackage {
      name = "tunnel-agent";
      version = "0.4.2";
      src = fetchurl {
        url = "http://registry.npmjs.org/tunnel-agent/-/tunnel-agent-0.4.2.tgz";
        sha1 = "1104e3f36ac87125c287270067d582d18133bfee";
      };
      dependencies = {};
      meta = {
        description = "HTTP proxy tunneling agent. Formerly part of mikeal/request, now a standalone module";
        homepage = "https://github.com/mikeal/tunnel-agent#readme";
        license = "Apache-2.0";
      };
      production = true;
      linkDependencies = false;
    };
    "tunnel-agent-~0.4.0" = self."tunnel-agent-0.4.2";
    "tough-cookie-2.2.1" = buildNodePackage {
      name = "tough-cookie";
      version = "2.2.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/tough-cookie/-/tough-cookie-2.2.1.tgz";
        sha1 = "3b0516b799e70e8164436a1446e7e5877fda118e";
      };
      meta = {
        description = "RFC6265 Cookies and Cookie Jar for node.js";
        homepage = https://github.com/SalesforceEng/tough-cookie;
        license = "BSD-3-Clause";
      };
      production = true;
      linkDependencies = false;
    };
    "tough-cookie->=0.12.0" = self."tough-cookie-2.2.1";
    "http-signature-0.11.0" = buildNodePackage {
      name = "http-signature";
      version = "0.11.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/http-signature/-/http-signature-0.11.0.tgz";
        sha1 = "1796cf67a001ad5cd6849dca0991485f09089fe6";
      };
      dependencies = {
        assert-plus = {
          "^0.1.5" = {
            version = "0.1.5";
            pkg = self."assert-plus-0.1.5";
          };
        };
        asn1 = {
          "0.1.11" = {
            version = "0.1.11";
            pkg = self."asn1-0.1.11";
          };
        };
        ctype = {
          "0.5.3" = {
            version = "0.5.3";
            pkg = self."ctype-0.5.3";
          };
        };
      };
      meta = {
        description = "Reference implementation of Joyent's HTTP Signature scheme";
        homepage = https://github.com/joyent/node-http-signature/;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "assert-plus-0.1.5" = buildNodePackage {
      name = "assert-plus";
      version = "0.1.5";
      src = fetchurl {
        url = "http://registry.npmjs.org/assert-plus/-/assert-plus-0.1.5.tgz";
        sha1 = "ee74009413002d84cec7219c6ac811812e723160";
      };
      dependencies = {};
      meta = {
        description = "Extra assertions on top of node's assert module";
      };
      production = true;
      linkDependencies = false;
    };
    "assert-plus-^0.1.5" = self."assert-plus-0.1.5";
    "asn1-0.1.11" = buildNodePackage {
      name = "asn1";
      version = "0.1.11";
      src = fetchurl {
        url = "http://registry.npmjs.org/asn1/-/asn1-0.1.11.tgz";
        sha1 = "559be18376d08a4ec4dbe80877d27818639b2df7";
      };
      dependencies = {};
      meta = {
        description = "Contains parsers and serializers for ASN.1 (currently BER only)";
      };
      production = true;
      linkDependencies = false;
    };
    "ctype-0.5.3" = buildNodePackage {
      name = "ctype";
      version = "0.5.3";
      src = fetchurl {
        url = "http://registry.npmjs.org/ctype/-/ctype-0.5.3.tgz";
        sha1 = "82c18c2461f74114ef16c135224ad0b9144ca12f";
      };
      meta = {
        description = "read and write binary structures and data types";
        homepage = https://github.com/rmustacc/node-ctype;
      };
      production = true;
      linkDependencies = false;
    };
    "http-signature-~0.11.0" = self."http-signature-0.11.0";
    "oauth-sign-0.8.0" = buildNodePackage {
      name = "oauth-sign";
      version = "0.8.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/oauth-sign/-/oauth-sign-0.8.0.tgz";
        sha1 = "938fdc875765ba527137d8aec9d178e24debc553";
      };
      dependencies = {};
      meta = {
        description = "OAuth 1 signing. Formerly a vendor lib in mikeal/request, now a standalone module";
        homepage = "https://github.com/mikeal/oauth-sign#readme";
        license = "Apache-2.0";
      };
      production = true;
      linkDependencies = false;
    };
    "oauth-sign-~0.8.0" = self."oauth-sign-0.8.0";
    "hawk-3.1.2" = buildNodePackage {
      name = "hawk";
      version = "3.1.2";
      src = fetchurl {
        url = "http://registry.npmjs.org/hawk/-/hawk-3.1.2.tgz";
        sha1 = "90c90118886e21975d1ad4ae9b3e284ed19a2de8";
      };
      dependencies = {
        hoek = {
          "2.x.x" = {
            version = "2.16.3";
            pkg = self."hoek-2.16.3";
          };
        };
        boom = {
          "2.x.x" = {
            version = "2.10.1";
            pkg = self."boom-2.10.1";
          };
        };
        cryptiles = {
          "2.x.x" = {
            version = "2.0.5";
            pkg = self."cryptiles-2.0.5";
          };
        };
        sntp = {
          "1.x.x" = {
            version = "1.0.9";
            pkg = self."sntp-1.0.9";
          };
        };
      };
      meta = {
        description = "HTTP Hawk Authentication Scheme";
        homepage = "https://github.com/hueniverse/hawk#readme";
        license = "BSD-3-Clause";
      };
      production = true;
      linkDependencies = false;
    };
    "hoek-2.16.3" = buildNodePackage {
      name = "hoek";
      version = "2.16.3";
      src = fetchurl {
        url = "http://registry.npmjs.org/hoek/-/hoek-2.16.3.tgz";
        sha1 = "20bb7403d3cea398e91dc4710a8ff1b8274a25ed";
      };
      dependencies = {};
      meta = {
        description = "General purpose node utilities";
        homepage = "https://github.com/hapijs/hoek#readme";
        license = "BSD-3-Clause";
      };
      production = true;
      linkDependencies = false;
    };
    "hoek-2.x.x" = self."hoek-2.16.3";
    "boom-2.10.1" = buildNodePackage {
      name = "boom";
      version = "2.10.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/boom/-/boom-2.10.1.tgz";
        sha1 = "39c8918ceff5799f83f9492a848f625add0c766f";
      };
      dependencies = {
        hoek = {
          "2.x.x" = {
            version = "2.16.3";
            pkg = self."hoek-2.16.3";
          };
        };
      };
      meta = {
        description = "HTTP-friendly error objects";
        homepage = "https://github.com/hapijs/boom#readme";
        license = "BSD-3-Clause";
      };
      production = true;
      linkDependencies = false;
    };
    "boom-2.x.x" = self."boom-2.10.1";
    "cryptiles-2.0.5" = buildNodePackage {
      name = "cryptiles";
      version = "2.0.5";
      src = fetchurl {
        url = "http://registry.npmjs.org/cryptiles/-/cryptiles-2.0.5.tgz";
        sha1 = "3bdfecdc608147c1c67202fa291e7dca59eaa3b8";
      };
      dependencies = {
        boom = {
          "2.x.x" = {
            version = "2.10.1";
            pkg = self."boom-2.10.1";
          };
        };
      };
      meta = {
        description = "General purpose crypto utilities";
        homepage = "https://github.com/hapijs/cryptiles#readme";
        license = "BSD-3-Clause";
      };
      production = true;
      linkDependencies = false;
    };
    "cryptiles-2.x.x" = self."cryptiles-2.0.5";
    "sntp-1.0.9" = buildNodePackage {
      name = "sntp";
      version = "1.0.9";
      src = fetchurl {
        url = "http://registry.npmjs.org/sntp/-/sntp-1.0.9.tgz";
        sha1 = "6541184cc90aeea6c6e7b35e2659082443c66198";
      };
      dependencies = {
        hoek = {
          "2.x.x" = {
            version = "2.16.3";
            pkg = self."hoek-2.16.3";
          };
        };
      };
      meta = {
        description = "SNTP Client";
        homepage = https://github.com/hueniverse/sntp;
      };
      production = true;
      linkDependencies = false;
    };
    "sntp-1.x.x" = self."sntp-1.0.9";
    "hawk-~3.1.0" = self."hawk-3.1.2";
    "aws-sign2-0.5.0" = buildNodePackage {
      name = "aws-sign2";
      version = "0.5.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/aws-sign2/-/aws-sign2-0.5.0.tgz";
        sha1 = "c57103f7a17fc037f02d7c2e64b602ea223f7d63";
      };
      dependencies = {};
      meta = {
        description = "AWS signing. Originally pulled from LearnBoost/knox, maintained as vendor in request, now a standalone module";
      };
      production = true;
      linkDependencies = false;
    };
    "aws-sign2-~0.5.0" = self."aws-sign2-0.5.0";
    "stringstream-0.0.5" = buildNodePackage {
      name = "stringstream";
      version = "0.0.5";
      src = fetchurl {
        url = "http://registry.npmjs.org/stringstream/-/stringstream-0.0.5.tgz";
        sha1 = "4e484cd4de5a0bbbee18e46307710a8a81621878";
      };
      meta = {
        description = "Encode and decode streams into string streams";
        homepage = "https://github.com/mhart/StringStream#readme";
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "stringstream-~0.0.4" = self."stringstream-0.0.5";
    "combined-stream-~1.0.1" = self."combined-stream-1.0.5";
    "isstream-0.1.2" = buildNodePackage {
      name = "isstream";
      version = "0.1.2";
      src = fetchurl {
        url = "http://registry.npmjs.org/isstream/-/isstream-0.1.2.tgz";
        sha1 = "47e63f7af55afa6f92e1500e690eb8b8529c099a";
      };
      meta = {
        description = "Determine if an object is a Stream";
        homepage = https://github.com/rvagg/isstream;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "isstream-~0.1.1" = self."isstream-0.1.2";
    "har-validator-1.8.0" = buildNodePackage {
      name = "har-validator";
      version = "1.8.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/har-validator/-/har-validator-1.8.0.tgz";
        sha1 = "d83842b0eb4c435960aeb108a067a3aa94c0eeb2";
      };
      dependencies = {
        bluebird = {
          "^2.9.30" = {
            version = "2.10.2";
            pkg = self."bluebird-2.10.2";
          };
        };
        chalk = {
          "^1.0.0" = {
            version = "1.1.1";
            pkg = self."chalk-1.1.1";
          };
        };
        commander = {
          "^2.8.1" = {
            version = "2.9.0";
            pkg = self."commander-2.9.0";
          };
        };
        is-my-json-valid = {
          "^2.12.0" = {
            version = "2.12.3";
            pkg = self."is-my-json-valid-2.12.3";
          };
        };
      };
      meta = {
        description = "Extremely fast HTTP Archive (HAR) validator using JSON Schema";
        homepage = https://github.com/ahmadnassri/har-validator;
        license = "ISC";
      };
      production = true;
      linkDependencies = false;
    };
    "bluebird-2.10.2" = buildNodePackage {
      name = "bluebird";
      version = "2.10.2";
      src = fetchurl {
        url = "http://registry.npmjs.org/bluebird/-/bluebird-2.10.2.tgz";
        sha1 = "024a5517295308857f14f91f1106fc3b555f446b";
      };
      meta = {
        description = "Full featured Promises/A+ implementation with exceptionally good performance";
        homepage = https://github.com/petkaantonov/bluebird;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "bluebird-^2.9.30" = self."bluebird-2.10.2";
    "chalk-1.1.1" = buildNodePackage {
      name = "chalk";
      version = "1.1.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/chalk/-/chalk-1.1.1.tgz";
        sha1 = "509afb67066e7499f7eb3535c77445772ae2d019";
      };
      dependencies = {
        ansi-styles = {
          "^2.1.0" = {
            version = "2.1.0";
            pkg = self."ansi-styles-2.1.0";
          };
        };
        escape-string-regexp = {
          "^1.0.2" = {
            version = "1.0.4";
            pkg = self."escape-string-regexp-1.0.4";
          };
        };
        has-ansi = {
          "^2.0.0" = {
            version = "2.0.0";
            pkg = self."has-ansi-2.0.0";
          };
        };
        strip-ansi = {
          "^3.0.0" = {
            version = "3.0.0";
            pkg = self."strip-ansi-3.0.0";
          };
        };
        supports-color = {
          "^2.0.0" = {
            version = "2.0.0";
            pkg = self."supports-color-2.0.0";
          };
        };
      };
      meta = {
        description = "Terminal string styling done right. Much color";
        homepage = "https://github.com/chalk/chalk#readme";
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "ansi-styles-2.1.0" = buildNodePackage {
      name = "ansi-styles";
      version = "2.1.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/ansi-styles/-/ansi-styles-2.1.0.tgz";
        sha1 = "990f747146927b559a932bf92959163d60c0d0e2";
      };
      meta = {
        description = "ANSI escape codes for styling strings in the terminal";
        homepage = https://github.com/chalk/ansi-styles;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "ansi-styles-^2.1.0" = self."ansi-styles-2.1.0";
    "escape-string-regexp-1.0.4" = buildNodePackage {
      name = "escape-string-regexp";
      version = "1.0.4";
      src = fetchurl {
        url = "http://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.4.tgz";
        sha1 = "b85e679b46f72d03fbbe8a3bf7259d535c21b62f";
      };
      meta = {
        description = "Escape RegExp special characters";
        homepage = https://github.com/sindresorhus/escape-string-regexp;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "escape-string-regexp-^1.0.2" = self."escape-string-regexp-1.0.4";
    "has-ansi-2.0.0" = buildNodePackage {
      name = "has-ansi";
      version = "2.0.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/has-ansi/-/has-ansi-2.0.0.tgz";
        sha1 = "34f5049ce1ecdf2b0649af3ef24e45ed35416d91";
      };
      dependencies = {
        ansi-regex = {
          "^2.0.0" = {
            version = "2.0.0";
            pkg = self."ansi-regex-2.0.0";
          };
        };
      };
      meta = {
        description = "Check if a string has ANSI escape codes";
        homepage = https://github.com/sindresorhus/has-ansi;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "ansi-regex-2.0.0" = buildNodePackage {
      name = "ansi-regex";
      version = "2.0.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/ansi-regex/-/ansi-regex-2.0.0.tgz";
        sha1 = "c5061b6e0ef8a81775e50f5d66151bf6bf371107";
      };
      meta = {
        description = "Regular expression for matching ANSI escape codes";
        homepage = https://github.com/sindresorhus/ansi-regex;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "ansi-regex-^2.0.0" = self."ansi-regex-2.0.0";
    "has-ansi-^2.0.0" = self."has-ansi-2.0.0";
    "strip-ansi-3.0.0" = buildNodePackage {
      name = "strip-ansi";
      version = "3.0.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/strip-ansi/-/strip-ansi-3.0.0.tgz";
        sha1 = "7510b665567ca914ccb5d7e072763ac968be3724";
      };
      dependencies = {
        ansi-regex = {
          "^2.0.0" = {
            version = "2.0.0";
            pkg = self."ansi-regex-2.0.0";
          };
        };
      };
      meta = {
        description = "Strip ANSI escape codes";
        homepage = https://github.com/sindresorhus/strip-ansi;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "strip-ansi-^3.0.0" = self."strip-ansi-3.0.0";
    "supports-color-2.0.0" = buildNodePackage {
      name = "supports-color";
      version = "2.0.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/supports-color/-/supports-color-2.0.0.tgz";
        sha1 = "535d045ce6b6363fa40117084629995e9df324c7";
      };
      meta = {
        description = "Detect whether a terminal supports color";
        homepage = https://github.com/chalk/supports-color;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "supports-color-^2.0.0" = self."supports-color-2.0.0";
    "chalk-^1.0.0" = self."chalk-1.1.1";
    "commander-2.9.0" = buildNodePackage {
      name = "commander";
      version = "2.9.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/commander/-/commander-2.9.0.tgz";
        sha1 = "9c99094176e12240cb22d6c5146098400fe0f7d4";
      };
      dependencies = {
        graceful-readlink = {
          ">= 1.0.0" = {
            version = "1.0.1";
            pkg = self."graceful-readlink-1.0.1";
          };
        };
      };
      meta = {
        description = "the complete solution for node.js command-line programs";
        homepage = "https://github.com/tj/commander.js#readme";
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "graceful-readlink-1.0.1" = buildNodePackage {
      name = "graceful-readlink";
      version = "1.0.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/graceful-readlink/-/graceful-readlink-1.0.1.tgz";
        sha1 = "4cafad76bc62f02fa039b2f94e9a3dd3a391a725";
      };
      meta = {
        description = "graceful fs.readlink";
        homepage = https://github.com/zhiyelee/graceful-readlink;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "graceful-readlink->= 1.0.0" = self."graceful-readlink-1.0.1";
    "commander-^2.8.1" = self."commander-2.9.0";
    "is-my-json-valid-2.12.3" = buildNodePackage {
      name = "is-my-json-valid";
      version = "2.12.3";
      src = fetchurl {
        url = "http://registry.npmjs.org/is-my-json-valid/-/is-my-json-valid-2.12.3.tgz";
        sha1 = "5a39d1d76b2dbb83140bbd157b1d5ee4bdc85ad6";
      };
      dependencies = {
        generate-function = {
          "^2.0.0" = {
            version = "2.0.0";
            pkg = self."generate-function-2.0.0";
          };
        };
        generate-object-property = {
          "^1.1.0" = {
            version = "1.2.0";
            pkg = self."generate-object-property-1.2.0";
          };
        };
        jsonpointer = {
          "2.0.0" = {
            version = "2.0.0";
            pkg = self."jsonpointer-2.0.0";
          };
        };
        xtend = {
          "^4.0.0" = {
            version = "4.0.1";
            pkg = self."xtend-4.0.1";
          };
        };
      };
      meta = {
        description = "A JSONSchema validator that uses code generation to be extremely fast";
        homepage = https://github.com/mafintosh/is-my-json-valid;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "generate-function-2.0.0" = buildNodePackage {
      name = "generate-function";
      version = "2.0.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/generate-function/-/generate-function-2.0.0.tgz";
        sha1 = "6858fe7c0969b7d4e9093337647ac79f60dfbe74";
      };
      meta = {
        description = "Module that helps you write generated functions in Node";
        homepage = https://github.com/mafintosh/generate-function;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "generate-function-^2.0.0" = self."generate-function-2.0.0";
    "generate-object-property-1.2.0" = buildNodePackage {
      name = "generate-object-property";
      version = "1.2.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/generate-object-property/-/generate-object-property-1.2.0.tgz";
        sha1 = "9c0e1c40308ce804f4783618b937fa88f99d50d0";
      };
      dependencies = {
        is-property = {
          "^1.0.0" = {
            version = "1.0.2";
            pkg = self."is-property-1.0.2";
          };
        };
      };
      meta = {
        description = "Generate safe JS code that can used to reference a object property";
        homepage = https://github.com/mafintosh/generate-object-property;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "is-property-1.0.2" = buildNodePackage {
      name = "is-property";
      version = "1.0.2";
      src = fetchurl {
        url = "http://registry.npmjs.org/is-property/-/is-property-1.0.2.tgz";
        sha1 = "57fe1c4e48474edd65b09911f26b1cd4095dda84";
      };
      dependencies = {};
      meta = {
        description = "Tests if a JSON property can be accessed using . syntax";
        homepage = https://github.com/mikolalysenko/is-property;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "is-property-^1.0.0" = self."is-property-1.0.2";
    "generate-object-property-^1.1.0" = self."generate-object-property-1.2.0";
    "jsonpointer-2.0.0" = buildNodePackage {
      name = "jsonpointer";
      version = "2.0.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/jsonpointer/-/jsonpointer-2.0.0.tgz";
        sha1 = "3af1dd20fe85463910d469a385e33017d2a030d9";
      };
      meta = {
        description = "Simple JSON Addressing";
        homepage = "https://github.com/janl/node-jsonpointer#readme";
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "xtend-4.0.1" = buildNodePackage {
      name = "xtend";
      version = "4.0.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/xtend/-/xtend-4.0.1.tgz";
        sha1 = "a5c6d532be656e23db820efb943a1f04998d63af";
      };
      dependencies = {};
      meta = {
        description = "extend like a boss";
        homepage = https://github.com/Raynos/xtend;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "xtend-^4.0.0" = self."xtend-4.0.1";
    "is-my-json-valid-^2.12.0" = self."is-my-json-valid-2.12.3";
    "har-validator-^1.6.1" = self."har-validator-1.8.0";
    "semver-5.0.1" = buildNodePackage {
      name = "semver";
      version = "5.0.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/semver/-/semver-5.0.1.tgz";
        sha1 = "9fb3f4004f900d83c47968fe42f7583e05832cc9";
      };
      meta = {
        description = "The semantic version parser used by npm";
        homepage = "https://github.com/npm/node-semver#readme";
        license = "ISC";
      };
      production = true;
      linkDependencies = false;
    };
    "temp-0.8.3" = buildNodePackage {
      name = "temp";
      version = "0.8.3";
      src = fetchurl {
        url = "http://registry.npmjs.org/temp/-/temp-0.8.3.tgz";
        sha1 = "e0c6bc4d26b903124410e4fed81103014dfc1f59";
      };
      dependencies = {
        os-tmpdir = {
          "^1.0.0" = {
            version = "1.0.1";
            pkg = self."os-tmpdir-1.0.1";
          };
        };
        rimraf = {
          "~2.2.6" = {
            version = "2.2.8";
            pkg = self."rimraf-2.2.8";
          };
        };
      };
      meta = {
        description = "Temporary files and directories";
        homepage = https://github.com/bruce/node-temp;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "os-tmpdir-1.0.1" = buildNodePackage {
      name = "os-tmpdir";
      version = "1.0.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/os-tmpdir/-/os-tmpdir-1.0.1.tgz";
        sha1 = "e9b423a1edaf479882562e92ed71d7743a071b6e";
      };
      meta = {
        description = "Node.js os.tmpdir() ponyfill";
        homepage = https://github.com/sindresorhus/os-tmpdir;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "os-tmpdir-^1.0.0" = self."os-tmpdir-1.0.1";
    "rimraf-2.2.8" = buildNodePackage {
      name = "rimraf";
      version = "2.2.8";
      src = fetchurl {
        url = "http://registry.npmjs.org/rimraf/-/rimraf-2.2.8.tgz";
        sha1 = "e439be2aaee327321952730f99a8929e4fc50582";
      };
      meta = {
        description = "A deep deletion module for node (like `rm -rf`)";
        homepage = https://github.com/isaacs/rimraf;
        license = {
          type = "MIT";
          url = "https://github.com/isaacs/rimraf/raw/master/LICENSE";
        };
      };
      production = true;
      linkDependencies = false;
    };
    "rimraf-~2.2.6" = self."rimraf-2.2.8";
    "wrench-1.5.8" = buildNodePackage {
      name = "wrench";
      version = "1.5.8";
      src = fetchurl {
        url = "http://registry.npmjs.org/wrench/-/wrench-1.5.8.tgz";
        sha1 = "7a31c97f7869246d76c5cf2f5c977a1c4c8e5ab5";
      };
      dependencies = {};
      meta = {
        description = "Recursive filesystem (and other) operations that Node *should* have";
        homepage = https://github.com/ryanmcgrath/wrench-js;
      };
      production = true;
      linkDependencies = false;
    };
    "uglify-js-2.4.24" = buildNodePackage {
      name = "uglify-js";
      version = "2.4.24";
      src = fetchurl {
        url = "http://registry.npmjs.org/uglify-js/-/uglify-js-2.4.24.tgz";
        sha1 = "fad5755c1e1577658bb06ff9ab6e548c95bebd6e";
      };
      dependencies = {
        async = {
          "~0.2.6" = {
            version = "0.2.10";
            pkg = self."async-0.2.10";
          };
        };
        source-map = {
          "0.1.34" = {
            version = "0.1.34";
            pkg = self."source-map-0.1.34";
          };
        };
        uglify-to-browserify = {
          "~1.0.0" = {
            version = "1.0.2";
            pkg = self."uglify-to-browserify-1.0.2";
          };
        };
        yargs = {
          "~3.5.4" = {
            version = "3.5.4";
            pkg = self."yargs-3.5.4";
          };
        };
      };
      meta = {
        description = "JavaScript parser, mangler/compressor and beautifier toolkit";
        homepage = http://lisperator.net/uglifyjs;
        license = "BSD";
      };
      production = true;
      linkDependencies = false;
    };
    "async-0.2.10" = buildNodePackage {
      name = "async";
      version = "0.2.10";
      src = fetchurl {
        url = "http://registry.npmjs.org/async/-/async-0.2.10.tgz";
        sha1 = "b6bbe0b0674b9d719708ca38de8c237cb526c3d1";
      };
      meta = {
        description = "Higher-order functions and common patterns for asynchronous code";
      };
      production = true;
      linkDependencies = false;
    };
    "async-~0.2.6" = self."async-0.2.10";
    "source-map-0.1.34" = buildNodePackage {
      name = "source-map";
      version = "0.1.34";
      src = fetchurl {
        url = "http://registry.npmjs.org/source-map/-/source-map-0.1.34.tgz";
        sha1 = "a7cfe89aec7b1682c3b198d0acfb47d7d090566b";
      };
      dependencies = {
        amdefine = {
          ">=0.0.4" = {
            version = "1.0.0";
            pkg = self."amdefine-1.0.0";
          };
        };
      };
      meta = {
        description = "Generates and consumes source maps";
        homepage = https://github.com/mozilla/source-map;
      };
      production = true;
      linkDependencies = false;
    };
    "uglify-to-browserify-1.0.2" = buildNodePackage {
      name = "uglify-to-browserify";
      version = "1.0.2";
      src = fetchurl {
        url = "http://registry.npmjs.org/uglify-to-browserify/-/uglify-to-browserify-1.0.2.tgz";
        sha1 = "6e0924d6bda6b5afe349e39a6d632850a0f882b7";
      };
      dependencies = {};
      meta = {
        description = "A transform to make UglifyJS work in browserify";
        homepage = https://github.com/ForbesLindesay/uglify-to-browserify;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "uglify-to-browserify-~1.0.0" = self."uglify-to-browserify-1.0.2";
    "yargs-3.5.4" = buildNodePackage {
      name = "yargs";
      version = "3.5.4";
      src = fetchurl {
        url = "http://registry.npmjs.org/yargs/-/yargs-3.5.4.tgz";
        sha1 = "d8aff8f665e94c34bd259bdebd1bfaf0ddd35361";
      };
      dependencies = {
        camelcase = {
          "^1.0.2" = {
            version = "1.2.1";
            pkg = self."camelcase-1.2.1";
          };
        };
        decamelize = {
          "^1.0.0" = {
            version = "1.1.2";
            pkg = self."decamelize-1.1.2";
          };
        };
        window-size = {
          "0.1.0" = {
            version = "0.1.0";
            pkg = self."window-size-0.1.0";
          };
        };
        wordwrap = {
          "0.0.2" = {
            version = "0.0.2";
            pkg = self."wordwrap-0.0.2";
          };
        };
      };
      meta = {
        description = "Light-weight option parsing with an argv hash. No optstrings attached";
        homepage = https://github.com/bcoe/yargs;
        license = "MIT/X11";
      };
      production = true;
      linkDependencies = false;
    };
    "camelcase-1.2.1" = buildNodePackage {
      name = "camelcase";
      version = "1.2.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/camelcase/-/camelcase-1.2.1.tgz";
        sha1 = "9bb5304d2e0b56698b2c758b08a3eaa9daa58a39";
      };
      meta = {
        description = "Convert a dash/dot/underscore/space separated string to camelCase: foo-bar → fooBar";
        homepage = https://github.com/sindresorhus/camelcase;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "camelcase-^1.0.2" = self."camelcase-1.2.1";
    "decamelize-1.1.2" = buildNodePackage {
      name = "decamelize";
      version = "1.1.2";
      src = fetchurl {
        url = "http://registry.npmjs.org/decamelize/-/decamelize-1.1.2.tgz";
        sha1 = "dcc93727be209632e98b02718ef4cb79602322f2";
      };
      dependencies = {
        escape-string-regexp = {
          "^1.0.4" = {
            version = "1.0.4";
            pkg = self."escape-string-regexp-1.0.4";
          };
        };
      };
      meta = {
        description = "Convert a camelized string into a lowercased one with a custom separator: unicornRainbow → unicorn_rainbow";
        homepage = https://github.com/sindresorhus/decamelize;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "escape-string-regexp-^1.0.4" = self."escape-string-regexp-1.0.4";
    "decamelize-^1.0.0" = self."decamelize-1.1.2";
    "window-size-0.1.0" = buildNodePackage {
      name = "window-size";
      version = "0.1.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/window-size/-/window-size-0.1.0.tgz";
        sha1 = "5438cd2ea93b202efa3a19fe8887aee7c94f9c9d";
      };
      meta = {
        description = "Reliable way to to get the height and width of the terminal/console in a node.js environment";
        homepage = https://github.com/jonschlinkert/window-size;
      };
      production = true;
      linkDependencies = false;
    };
    "wordwrap-0.0.2" = buildNodePackage {
      name = "wordwrap";
      version = "0.0.2";
      src = fetchurl {
        url = "http://registry.npmjs.org/wordwrap/-/wordwrap-0.0.2.tgz";
        sha1 = "b79669bb42ecb409f83d583cad52ca17eaa1643f";
      };
      dependencies = {};
      meta = {
        description = "Wrap those words. Show them at what columns to start and stop";
        license = "MIT/X11";
      };
      production = true;
      linkDependencies = false;
    };
    "yargs-~3.5.4" = self."yargs-3.5.4";
    "xmldom-0.1.19" = buildNodePackage {
      name = "xmldom";
      version = "0.1.19";
      src = fetchurl {
        url = "http://registry.npmjs.org/xmldom/-/xmldom-0.1.19.tgz";
        sha1 = "631fc07776efd84118bf25171b37ed4d075a0abc";
      };
      dependencies = {};
      meta = {
        description = "A W3C Standard XML DOM(Level2 CORE) implementation and parser(DOMParser/XMLSerializer)";
        homepage = https://github.com/jindw/xmldom;
      };
      production = true;
      linkDependencies = false;
    };
    "request-2.62.0" = buildNodePackage {
      name = "request";
      version = "2.62.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.62.0.tgz";
        sha1 = "55c165f702a146f1e21e0725c0b75e1136487b0f";
      };
      dependencies = {
        bl = {
          "~1.0.0" = {
            version = "1.0.0";
            pkg = self."bl-1.0.0";
          };
        };
        caseless = {
          "~0.11.0" = {
            version = "0.11.0";
            pkg = self."caseless-0.11.0";
          };
        };
        extend = {
          "~3.0.0" = {
            version = "3.0.0";
            pkg = self."extend-3.0.0";
          };
        };
        forever-agent = {
          "~0.6.0" = {
            version = "0.6.1";
            pkg = self."forever-agent-0.6.1";
          };
        };
        form-data = {
          "~1.0.0-rc1" = {
            version = "1.0.0-rc3";
            pkg = self."form-data-1.0.0-rc3";
          };
        };
        json-stringify-safe = {
          "~5.0.0" = {
            version = "5.0.1";
            pkg = self."json-stringify-safe-5.0.1";
          };
        };
        mime-types = {
          "~2.1.2" = {
            version = "2.1.8";
            pkg = self."mime-types-2.1.8";
          };
        };
        node-uuid = {
          "~1.4.0" = {
            version = "1.4.7";
            pkg = self."node-uuid-1.4.7";
          };
        };
        qs = {
          "~5.1.0" = {
            version = "5.1.0";
            pkg = self."qs-5.1.0";
          };
        };
        tunnel-agent = {
          "~0.4.0" = {
            version = "0.4.2";
            pkg = self."tunnel-agent-0.4.2";
          };
        };
        tough-cookie = {
          ">=0.12.0" = {
            version = "2.2.1";
            pkg = self."tough-cookie-2.2.1";
          };
        };
        http-signature = {
          "~0.11.0" = {
            version = "0.11.0";
            pkg = self."http-signature-0.11.0";
          };
        };
        oauth-sign = {
          "~0.8.0" = {
            version = "0.8.0";
            pkg = self."oauth-sign-0.8.0";
          };
        };
        hawk = {
          "~3.1.0" = {
            version = "3.1.2";
            pkg = self."hawk-3.1.2";
          };
        };
        aws-sign2 = {
          "~0.5.0" = {
            version = "0.5.0";
            pkg = self."aws-sign2-0.5.0";
          };
        };
        stringstream = {
          "~0.0.4" = {
            version = "0.0.5";
            pkg = self."stringstream-0.0.5";
          };
        };
        combined-stream = {
          "~1.0.1" = {
            version = "1.0.5";
            pkg = self."combined-stream-1.0.5";
          };
        };
        isstream = {
          "~0.1.1" = {
            version = "0.1.2";
            pkg = self."isstream-0.1.2";
          };
        };
        har-validator = {
          "^1.6.1" = {
            version = "1.8.0";
            pkg = self."har-validator-1.8.0";
          };
        };
      };
      meta = {
        description = "Simplified HTTP request client";
        homepage = "https://github.com/request/request#readme";
        license = "Apache-2.0";
      };
      production = true;
      linkDependencies = false;
    };
    "qs-5.1.0" = buildNodePackage {
      name = "qs";
      version = "5.1.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/qs/-/qs-5.1.0.tgz";
        sha1 = "4d932e5c7ea411cca76a312d39a606200fd50cd9";
      };
      dependencies = {};
      meta = {
        description = "A querystring parser that supports nesting and arrays, with a depth limit";
        homepage = https://github.com/hapijs/qs;
        license = "BSD-3-Clause";
      };
      production = true;
      linkDependencies = false;
    };
    "qs-~5.1.0" = self."qs-5.1.0";
    "semver-5.0.3" = buildNodePackage {
      name = "semver";
      version = "5.0.3";
      src = fetchurl {
        url = "http://registry.npmjs.org/semver/-/semver-5.0.3.tgz";
        sha1 = "77466de589cd5d3c95f138aa78bc569a3cb5d27a";
      };
      meta = {
        description = "The semantic version parser used by npm";
        homepage = "https://github.com/npm/node-semver#readme";
        license = "ISC";
      };
      production = true;
      linkDependencies = false;
    };
    "winston-1.0.2" = buildNodePackage {
      name = "winston";
      version = "1.0.2";
      src = fetchurl {
        url = "http://registry.npmjs.org/winston/-/winston-1.0.2.tgz";
        sha1 = "351c58e2323f8a4ca29a45195aa9aa3b4c35d76f";
      };
      dependencies = {
        async = {
          "~1.0.0" = {
            version = "1.0.0";
            pkg = self."async-1.0.0";
          };
        };
        colors = {
          "1.0.x" = {
            version = "1.0.3";
            pkg = self."colors-1.0.3";
          };
        };
        cycle = {
          "1.0.x" = {
            version = "1.0.3";
            pkg = self."cycle-1.0.3";
          };
        };
        eyes = {
          "0.1.x" = {
            version = "0.1.8";
            pkg = self."eyes-0.1.8";
          };
        };
        isstream = {
          "0.1.x" = {
            version = "0.1.2";
            pkg = self."isstream-0.1.2";
          };
        };
        pkginfo = {
          "0.3.x" = {
            version = "0.3.1";
            pkg = self."pkginfo-0.3.1";
          };
        };
        stack-trace = {
          "0.0.x" = {
            version = "0.0.9";
            pkg = self."stack-trace-0.0.9";
          };
        };
      };
      meta = {
        description = "A multi-transport async logging library for Node.js";
        homepage = "https://github.com/winstonjs/winston#readme";
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "async-1.0.0" = buildNodePackage {
      name = "async";
      version = "1.0.0";
      src = fetchurl {
        url = "http://registry.npmjs.org/async/-/async-1.0.0.tgz";
        sha1 = "f8fc04ca3a13784ade9e1641af98578cfbd647a9";
      };
      meta = {
        description = "Higher-order functions and common patterns for asynchronous code";
        homepage = "https://github.com/caolan/async#readme";
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "async-~1.0.0" = self."async-1.0.0";
    "colors-1.0.3" = buildNodePackage {
      name = "colors";
      version = "1.0.3";
      src = fetchurl {
        url = "http://registry.npmjs.org/colors/-/colors-1.0.3.tgz";
        sha1 = "0433f44d809680fdeb60ed260f1b0c262e82a40b";
      };
      meta = {
        description = "get colors in your node.js console";
        homepage = https://github.com/Marak/colors.js;
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "colors-1.0.x" = self."colors-1.0.3";
    "cycle-1.0.3" = buildNodePackage {
      name = "cycle";
      version = "1.0.3";
      src = fetchurl {
        url = "http://registry.npmjs.org/cycle/-/cycle-1.0.3.tgz";
        sha1 = "21e80b2be8580f98b468f379430662b046c34ad2";
      };
      meta = {
        description = "decycle your json";
        homepage = https://github.com/douglascrockford/JSON-js;
      };
      production = true;
      linkDependencies = false;
    };
    "cycle-1.0.x" = self."cycle-1.0.3";
    "eyes-0.1.8" = buildNodePackage {
      name = "eyes";
      version = "0.1.8";
      src = fetchurl {
        url = "http://registry.npmjs.org/eyes/-/eyes-0.1.8.tgz";
        sha1 = "62cf120234c683785d902348a800ef3e0cc20bc0";
      };
      meta = {
        description = "a customizable value inspector";
      };
      production = true;
      linkDependencies = false;
    };
    "eyes-0.1.x" = self."eyes-0.1.8";
    "isstream-0.1.x" = self."isstream-0.1.2";
    "pkginfo-0.3.1" = buildNodePackage {
      name = "pkginfo";
      version = "0.3.1";
      src = fetchurl {
        url = "http://registry.npmjs.org/pkginfo/-/pkginfo-0.3.1.tgz";
        sha1 = "5b29f6a81f70717142e09e765bbeab97b4f81e21";
      };
      meta = {
        description = "An easy way to expose properties on a module from a package.json";
        homepage = "https://github.com/indexzero/node-pkginfo#readme";
        license = "MIT";
      };
      production = true;
      linkDependencies = false;
    };
    "pkginfo-0.3.x" = self."pkginfo-0.3.1";
    "stack-trace-0.0.9" = buildNodePackage {
      name = "stack-trace";
      version = "0.0.9";
      src = fetchurl {
        url = "http://registry.npmjs.org/stack-trace/-/stack-trace-0.0.9.tgz";
        sha1 = "a8f6eaeca90674c333e7c43953f275b451510695";
      };
      dependencies = {};
      meta = {
        description = "Get v8 stack traces as an array of CallSite objects";
        homepage = https://github.com/felixge/node-stack-trace;
      };
      production = true;
      linkDependencies = false;
    };
    "stack-trace-0.0.x" = self."stack-trace-0.0.9";
    "winston-1.0.x" = self."winston-1.0.2";
    titanium = self."titanium-5.0.5";
  };
in
registry