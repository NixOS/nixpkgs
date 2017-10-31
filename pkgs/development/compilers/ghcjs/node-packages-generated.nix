{ self, fetchurl, fetchgit ? null, lib }:

{
  by-spec."accepts"."1.1.4" =
    self.by-version."accepts"."1.1.4";
  by-version."accepts"."1.1.4" = self.buildNodePackage {
    name = "accepts-1.1.4";
    version = "1.1.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/accepts/-/accepts-1.1.4.tgz";
      name = "accepts-1.1.4.tgz";
      sha1 = "d71c96f7d41d0feda2c38cd14e8a27c04158df4a";
    };
    deps = {
      "mime-types-2.0.14" = self.by-version."mime-types"."2.0.14";
      "negotiator-0.4.9" = self.by-version."negotiator"."0.4.9";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."after"."0.8.1" =
    self.by-version."after"."0.8.1";
  by-version."after"."0.8.1" = self.buildNodePackage {
    name = "after-0.8.1";
    version = "0.8.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/after/-/after-0.8.1.tgz";
      name = "after-0.8.1.tgz";
      sha1 = "ab5d4fb883f596816d3515f8f791c0af486dd627";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."arraybuffer.slice"."0.0.6" =
    self.by-version."arraybuffer.slice"."0.0.6";
  by-version."arraybuffer.slice"."0.0.6" = self.buildNodePackage {
    name = "arraybuffer.slice-0.0.6";
    version = "0.0.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/arraybuffer.slice/-/arraybuffer.slice-0.0.6.tgz";
      name = "arraybuffer.slice-0.0.6.tgz";
      sha1 = "f33b2159f0532a3f3107a272c0ccfbd1ad2979ca";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."backo2"."1.0.2" =
    self.by-version."backo2"."1.0.2";
  by-version."backo2"."1.0.2" = self.buildNodePackage {
    name = "backo2-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/backo2/-/backo2-1.0.2.tgz";
      name = "backo2-1.0.2.tgz";
      sha1 = "31ab1ac8b129363463e35b3ebb69f4dfcfba7947";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."base64-arraybuffer"."0.1.2" =
    self.by-version."base64-arraybuffer"."0.1.2";
  by-version."base64-arraybuffer"."0.1.2" = self.buildNodePackage {
    name = "base64-arraybuffer-0.1.2";
    version = "0.1.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/base64-arraybuffer/-/base64-arraybuffer-0.1.2.tgz";
      name = "base64-arraybuffer-0.1.2.tgz";
      sha1 = "474df4a9f2da24e05df3158c3b1db3c3cd46a154";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."base64id"."0.1.0" =
    self.by-version."base64id"."0.1.0";
  by-version."base64id"."0.1.0" = self.buildNodePackage {
    name = "base64id-0.1.0";
    version = "0.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/base64id/-/base64id-0.1.0.tgz";
      name = "base64id-0.1.0.tgz";
      sha1 = "02ce0fdeee0cef4f40080e1e73e834f0b1bfce3f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."benchmark"."1.0.0" =
    self.by-version."benchmark"."1.0.0";
  by-version."benchmark"."1.0.0" = self.buildNodePackage {
    name = "benchmark-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/benchmark/-/benchmark-1.0.0.tgz";
      name = "benchmark-1.0.0.tgz";
      sha1 = "2f1e2fa4c359f11122aa183082218e957e390c73";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."better-assert"."~1.0.0" =
    self.by-version."better-assert"."1.0.2";
  by-version."better-assert"."1.0.2" = self.buildNodePackage {
    name = "better-assert-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/better-assert/-/better-assert-1.0.2.tgz";
      name = "better-assert-1.0.2.tgz";
      sha1 = "40866b9e1b9e0b55b481894311e68faffaebc522";
    };
    deps = {
      "callsite-1.0.0" = self.by-version."callsite"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."blob"."0.0.4" =
    self.by-version."blob"."0.0.4";
  by-version."blob"."0.0.4" = self.buildNodePackage {
    name = "blob-0.0.4";
    version = "0.0.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/blob/-/blob-0.0.4.tgz";
      name = "blob-0.0.4.tgz";
      sha1 = "bcf13052ca54463f30f9fc7e95b9a47630a94921";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."callsite"."1.0.0" =
    self.by-version."callsite"."1.0.0";
  by-version."callsite"."1.0.0" = self.buildNodePackage {
    name = "callsite-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/callsite/-/callsite-1.0.0.tgz";
      name = "callsite-1.0.0.tgz";
      sha1 = "280398e5d664bd74038b6f0905153e6e8af1bc20";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."component-bind"."1.0.0" =
    self.by-version."component-bind"."1.0.0";
  by-version."component-bind"."1.0.0" = self.buildNodePackage {
    name = "component-bind-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/component-bind/-/component-bind-1.0.0.tgz";
      name = "component-bind-1.0.0.tgz";
      sha1 = "00c608ab7dcd93897c0009651b1d3a8e1e73bbd1";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."component-emitter"."1.1.2" =
    self.by-version."component-emitter"."1.1.2";
  by-version."component-emitter"."1.1.2" = self.buildNodePackage {
    name = "component-emitter-1.1.2";
    version = "1.1.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/component-emitter/-/component-emitter-1.1.2.tgz";
      name = "component-emitter-1.1.2.tgz";
      sha1 = "296594f2753daa63996d2af08d15a95116c9aec3";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."component-emitter"."1.2.0" =
    self.by-version."component-emitter"."1.2.0";
  by-version."component-emitter"."1.2.0" = self.buildNodePackage {
    name = "component-emitter-1.2.0";
    version = "1.2.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/component-emitter/-/component-emitter-1.2.0.tgz";
      name = "component-emitter-1.2.0.tgz";
      sha1 = "ccd113a86388d06482d03de3fc7df98526ba8efe";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."component-inherit"."0.0.3" =
    self.by-version."component-inherit"."0.0.3";
  by-version."component-inherit"."0.0.3" = self.buildNodePackage {
    name = "component-inherit-0.0.3";
    version = "0.0.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/component-inherit/-/component-inherit-0.0.3.tgz";
      name = "component-inherit-0.0.3.tgz";
      sha1 = "645fc4adf58b72b649d5cae65135619db26ff143";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."debug"."0.7.4" =
    self.by-version."debug"."0.7.4";
  by-version."debug"."0.7.4" = self.buildNodePackage {
    name = "debug-0.7.4";
    version = "0.7.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/debug/-/debug-0.7.4.tgz";
      name = "debug-0.7.4.tgz";
      sha1 = "06e1ea8082c2cb14e39806e22e2f6f757f92af39";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."debug"."2.2.0" =
    self.by-version."debug"."2.2.0";
  by-version."debug"."2.2.0" = self.buildNodePackage {
    name = "debug-2.2.0";
    version = "2.2.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/debug/-/debug-2.2.0.tgz";
      name = "debug-2.2.0.tgz";
      sha1 = "f87057e995b1a1f6ae6a4960664137bc56f039da";
    };
    deps = {
      "ms-0.7.1" = self.by-version."ms"."0.7.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."engine.io"."1.6.8" =
    self.by-version."engine.io"."1.6.8";
  by-version."engine.io"."1.6.8" = self.buildNodePackage {
    name = "engine.io-1.6.8";
    version = "1.6.8";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/engine.io/-/engine.io-1.6.8.tgz";
      name = "engine.io-1.6.8.tgz";
      sha1 = "de05a06b757e7517695e088c7b051c47819f511b";
    };
    deps = {
      "base64id-0.1.0" = self.by-version."base64id"."0.1.0";
      "debug-2.2.0" = self.by-version."debug"."2.2.0";
      "ws-1.0.1" = self.by-version."ws"."1.0.1";
      "engine.io-parser-1.2.4" = self.by-version."engine.io-parser"."1.2.4";
      "accepts-1.1.4" = self.by-version."accepts"."1.1.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."engine.io-client"."1.6.8" =
    self.by-version."engine.io-client"."1.6.8";
  by-version."engine.io-client"."1.6.8" = self.buildNodePackage {
    name = "engine.io-client-1.6.8";
    version = "1.6.8";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/engine.io-client/-/engine.io-client-1.6.8.tgz";
      name = "engine.io-client-1.6.8.tgz";
      sha1 = "6e2db11648b45e405c46b172ea3e3dac37cc0ceb";
    };
    deps = {
      "has-cors-1.1.0" = self.by-version."has-cors"."1.1.0";
      "ws-1.0.1" = self.by-version."ws"."1.0.1";
      "xmlhttprequest-ssl-1.5.1" = self.by-version."xmlhttprequest-ssl"."1.5.1";
      "component-emitter-1.1.2" = self.by-version."component-emitter"."1.1.2";
      "indexof-0.0.1" = self.by-version."indexof"."0.0.1";
      "engine.io-parser-1.2.4" = self.by-version."engine.io-parser"."1.2.4";
      "debug-2.2.0" = self.by-version."debug"."2.2.0";
      "parseuri-0.0.4" = self.by-version."parseuri"."0.0.4";
      "parsejson-0.0.1" = self.by-version."parsejson"."0.0.1";
      "parseqs-0.0.2" = self.by-version."parseqs"."0.0.2";
      "component-inherit-0.0.3" = self.by-version."component-inherit"."0.0.3";
      "yeast-0.1.2" = self.by-version."yeast"."0.1.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."engine.io-parser"."1.2.4" =
    self.by-version."engine.io-parser"."1.2.4";
  by-version."engine.io-parser"."1.2.4" = self.buildNodePackage {
    name = "engine.io-parser-1.2.4";
    version = "1.2.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/engine.io-parser/-/engine.io-parser-1.2.4.tgz";
      name = "engine.io-parser-1.2.4.tgz";
      sha1 = "e0897b0bf14e792d4cd2a5950553919c56948c42";
    };
    deps = {
      "after-0.8.1" = self.by-version."after"."0.8.1";
      "arraybuffer.slice-0.0.6" = self.by-version."arraybuffer.slice"."0.0.6";
      "base64-arraybuffer-0.1.2" = self.by-version."base64-arraybuffer"."0.1.2";
      "blob-0.0.4" = self.by-version."blob"."0.0.4";
      "has-binary-0.1.6" = self.by-version."has-binary"."0.1.6";
      "utf8-2.1.0" = self.by-version."utf8"."2.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."has-binary"."0.1.6" =
    self.by-version."has-binary"."0.1.6";
  by-version."has-binary"."0.1.6" = self.buildNodePackage {
    name = "has-binary-0.1.6";
    version = "0.1.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/has-binary/-/has-binary-0.1.6.tgz";
      name = "has-binary-0.1.6.tgz";
      sha1 = "25326f39cfa4f616ad8787894e3af2cfbc7b6e10";
    };
    deps = {
      "isarray-0.0.1" = self.by-version."isarray"."0.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."has-binary"."0.1.7" =
    self.by-version."has-binary"."0.1.7";
  by-version."has-binary"."0.1.7" = self.buildNodePackage {
    name = "has-binary-0.1.7";
    version = "0.1.7";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/has-binary/-/has-binary-0.1.7.tgz";
      name = "has-binary-0.1.7.tgz";
      sha1 = "68e61eb16210c9545a0a5cce06a873912fe1e68c";
    };
    deps = {
      "isarray-0.0.1" = self.by-version."isarray"."0.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."has-cors"."1.1.0" =
    self.by-version."has-cors"."1.1.0";
  by-version."has-cors"."1.1.0" = self.buildNodePackage {
    name = "has-cors-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/has-cors/-/has-cors-1.1.0.tgz";
      name = "has-cors-1.1.0.tgz";
      sha1 = "5e474793f7ea9843d1bb99c23eef49ff126fff39";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."indexof"."0.0.1" =
    self.by-version."indexof"."0.0.1";
  by-version."indexof"."0.0.1" = self.buildNodePackage {
    name = "indexof-0.0.1";
    version = "0.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/indexof/-/indexof-0.0.1.tgz";
      name = "indexof-0.0.1.tgz";
      sha1 = "82dc336d232b9062179d05ab3293a66059fd435d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."isarray"."0.0.1" =
    self.by-version."isarray"."0.0.1";
  by-version."isarray"."0.0.1" = self.buildNodePackage {
    name = "isarray-0.0.1";
    version = "0.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/isarray/-/isarray-0.0.1.tgz";
      name = "isarray-0.0.1.tgz";
      sha1 = "8a18acfca9a8f4177e09abfc6038939b05d1eedf";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."json3"."3.2.6" =
    self.by-version."json3"."3.2.6";
  by-version."json3"."3.2.6" = self.buildNodePackage {
    name = "json3-3.2.6";
    version = "3.2.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/json3/-/json3-3.2.6.tgz";
      name = "json3-3.2.6.tgz";
      sha1 = "f6efc93c06a04de9aec53053df2559bb19e2038b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."json3"."3.3.2" =
    self.by-version."json3"."3.3.2";
  by-version."json3"."3.3.2" = self.buildNodePackage {
    name = "json3-3.3.2";
    version = "3.3.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/json3/-/json3-3.3.2.tgz";
      name = "json3-3.3.2.tgz";
      sha1 = "3c0434743df93e2f5c42aee7b19bcb483575f4e1";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mime-db"."~1.12.0" =
    self.by-version."mime-db"."1.12.0";
  by-version."mime-db"."1.12.0" = self.buildNodePackage {
    name = "mime-db-1.12.0";
    version = "1.12.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/mime-db/-/mime-db-1.12.0.tgz";
      name = "mime-db-1.12.0.tgz";
      sha1 = "3d0c63180f458eb10d325aaa37d7c58ae312e9d7";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mime-types"."~2.0.4" =
    self.by-version."mime-types"."2.0.14";
  by-version."mime-types"."2.0.14" = self.buildNodePackage {
    name = "mime-types-2.0.14";
    version = "2.0.14";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/mime-types/-/mime-types-2.0.14.tgz";
      name = "mime-types-2.0.14.tgz";
      sha1 = "310e159db23e077f8bb22b748dabfa4957140aa6";
    };
    deps = {
      "mime-db-1.12.0" = self.by-version."mime-db"."1.12.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ms"."0.7.1" =
    self.by-version."ms"."0.7.1";
  by-version."ms"."0.7.1" = self.buildNodePackage {
    name = "ms-0.7.1";
    version = "0.7.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ms/-/ms-0.7.1.tgz";
      name = "ms-0.7.1.tgz";
      sha1 = "9cd13c03adbff25b65effde7ce864ee952017098";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."negotiator"."0.4.9" =
    self.by-version."negotiator"."0.4.9";
  by-version."negotiator"."0.4.9" = self.buildNodePackage {
    name = "negotiator-0.4.9";
    version = "0.4.9";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/negotiator/-/negotiator-0.4.9.tgz";
      name = "negotiator-0.4.9.tgz";
      sha1 = "92e46b6db53c7e421ed64a2bc94f08be7630df3f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."object-component"."0.0.3" =
    self.by-version."object-component"."0.0.3";
  by-version."object-component"."0.0.3" = self.buildNodePackage {
    name = "object-component-0.0.3";
    version = "0.0.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/object-component/-/object-component-0.0.3.tgz";
      name = "object-component-0.0.3.tgz";
      sha1 = "f0c69aa50efc95b866c186f400a33769cb2f1291";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."options".">=0.0.5" =
    self.by-version."options"."0.0.6";
  by-version."options"."0.0.6" = self.buildNodePackage {
    name = "options-0.0.6";
    version = "0.0.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/options/-/options-0.0.6.tgz";
      name = "options-0.0.6.tgz";
      sha1 = "ec22d312806bb53e731773e7cdaefcf1c643128f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."parsejson"."0.0.1" =
    self.by-version."parsejson"."0.0.1";
  by-version."parsejson"."0.0.1" = self.buildNodePackage {
    name = "parsejson-0.0.1";
    version = "0.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/parsejson/-/parsejson-0.0.1.tgz";
      name = "parsejson-0.0.1.tgz";
      sha1 = "9b10c6c0d825ab589e685153826de0a3ba278bcc";
    };
    deps = {
      "better-assert-1.0.2" = self.by-version."better-assert"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."parseqs"."0.0.2" =
    self.by-version."parseqs"."0.0.2";
  by-version."parseqs"."0.0.2" = self.buildNodePackage {
    name = "parseqs-0.0.2";
    version = "0.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/parseqs/-/parseqs-0.0.2.tgz";
      name = "parseqs-0.0.2.tgz";
      sha1 = "9dfe70b2cddac388bde4f35b1f240fa58adbe6c7";
    };
    deps = {
      "better-assert-1.0.2" = self.by-version."better-assert"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."parseuri"."0.0.4" =
    self.by-version."parseuri"."0.0.4";
  by-version."parseuri"."0.0.4" = self.buildNodePackage {
    name = "parseuri-0.0.4";
    version = "0.0.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/parseuri/-/parseuri-0.0.4.tgz";
      name = "parseuri-0.0.4.tgz";
      sha1 = "806582a39887e1ea18dd5e2fe0e01902268e9350";
    };
    deps = {
      "better-assert-1.0.2" = self.by-version."better-assert"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."socket.io"."*" =
    self.by-version."socket.io"."1.4.5";
  by-version."socket.io"."1.4.5" = self.buildNodePackage {
    name = "socket.io-1.4.5";
    version = "1.4.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/socket.io/-/socket.io-1.4.5.tgz";
      name = "socket.io-1.4.5.tgz";
      sha1 = "f202f49eeb9cf7cf6c0971ad75d8d96d451ea4f7";
    };
    deps = {
      "engine.io-1.6.8" = self.by-version."engine.io"."1.6.8";
      "socket.io-parser-2.2.6" = self.by-version."socket.io-parser"."2.2.6";
      "socket.io-client-1.4.5" = self.by-version."socket.io-client"."1.4.5";
      "socket.io-adapter-0.4.0" = self.by-version."socket.io-adapter"."0.4.0";
      "has-binary-0.1.7" = self.by-version."has-binary"."0.1.7";
      "debug-2.2.0" = self.by-version."debug"."2.2.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "socket.io" = self.by-version."socket.io"."1.4.5";
  by-spec."socket.io-adapter"."0.4.0" =
    self.by-version."socket.io-adapter"."0.4.0";
  by-version."socket.io-adapter"."0.4.0" = self.buildNodePackage {
    name = "socket.io-adapter-0.4.0";
    version = "0.4.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/socket.io-adapter/-/socket.io-adapter-0.4.0.tgz";
      name = "socket.io-adapter-0.4.0.tgz";
      sha1 = "fb9f82ab1aa65290bf72c3657955b930a991a24f";
    };
    deps = {
      "debug-2.2.0" = self.by-version."debug"."2.2.0";
      "socket.io-parser-2.2.2" = self.by-version."socket.io-parser"."2.2.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."socket.io-client"."1.4.5" =
    self.by-version."socket.io-client"."1.4.5";
  by-version."socket.io-client"."1.4.5" = self.buildNodePackage {
    name = "socket.io-client-1.4.5";
    version = "1.4.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/socket.io-client/-/socket.io-client-1.4.5.tgz";
      name = "socket.io-client-1.4.5.tgz";
      sha1 = "400d630c31e7c9579e45173f977e4f5bd8dc7d2e";
    };
    deps = {
      "debug-2.2.0" = self.by-version."debug"."2.2.0";
      "engine.io-client-1.6.8" = self.by-version."engine.io-client"."1.6.8";
      "component-bind-1.0.0" = self.by-version."component-bind"."1.0.0";
      "component-emitter-1.2.0" = self.by-version."component-emitter"."1.2.0";
      "object-component-0.0.3" = self.by-version."object-component"."0.0.3";
      "socket.io-parser-2.2.6" = self.by-version."socket.io-parser"."2.2.6";
      "has-binary-0.1.7" = self.by-version."has-binary"."0.1.7";
      "indexof-0.0.1" = self.by-version."indexof"."0.0.1";
      "parseuri-0.0.4" = self.by-version."parseuri"."0.0.4";
      "to-array-0.1.4" = self.by-version."to-array"."0.1.4";
      "backo2-1.0.2" = self.by-version."backo2"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."socket.io-parser"."2.2.2" =
    self.by-version."socket.io-parser"."2.2.2";
  by-version."socket.io-parser"."2.2.2" = self.buildNodePackage {
    name = "socket.io-parser-2.2.2";
    version = "2.2.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/socket.io-parser/-/socket.io-parser-2.2.2.tgz";
      name = "socket.io-parser-2.2.2.tgz";
      sha1 = "3d7af6b64497e956b7d9fe775f999716027f9417";
    };
    deps = {
      "debug-0.7.4" = self.by-version."debug"."0.7.4";
      "json3-3.2.6" = self.by-version."json3"."3.2.6";
      "component-emitter-1.1.2" = self.by-version."component-emitter"."1.1.2";
      "isarray-0.0.1" = self.by-version."isarray"."0.0.1";
      "benchmark-1.0.0" = self.by-version."benchmark"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."socket.io-parser"."2.2.6" =
    self.by-version."socket.io-parser"."2.2.6";
  by-version."socket.io-parser"."2.2.6" = self.buildNodePackage {
    name = "socket.io-parser-2.2.6";
    version = "2.2.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/socket.io-parser/-/socket.io-parser-2.2.6.tgz";
      name = "socket.io-parser-2.2.6.tgz";
      sha1 = "38dfd61df50dcf8ab1d9e2091322bf902ba28b99";
    };
    deps = {
      "debug-2.2.0" = self.by-version."debug"."2.2.0";
      "json3-3.3.2" = self.by-version."json3"."3.3.2";
      "component-emitter-1.1.2" = self.by-version."component-emitter"."1.1.2";
      "isarray-0.0.1" = self.by-version."isarray"."0.0.1";
      "benchmark-1.0.0" = self.by-version."benchmark"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."to-array"."0.1.4" =
    self.by-version."to-array"."0.1.4";
  by-version."to-array"."0.1.4" = self.buildNodePackage {
    name = "to-array-0.1.4";
    version = "0.1.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/to-array/-/to-array-0.1.4.tgz";
      name = "to-array-0.1.4.tgz";
      sha1 = "17e6c11f73dd4f3d74cda7a4ff3238e9ad9bf890";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ultron"."1.0.x" =
    self.by-version."ultron"."1.0.2";
  by-version."ultron"."1.0.2" = self.buildNodePackage {
    name = "ultron-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ultron/-/ultron-1.0.2.tgz";
      name = "ultron-1.0.2.tgz";
      sha1 = "ace116ab557cd197386a4e88f4685378c8b2e4fa";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."utf8"."2.1.0" =
    self.by-version."utf8"."2.1.0";
  by-version."utf8"."2.1.0" = self.buildNodePackage {
    name = "utf8-2.1.0";
    version = "2.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/utf8/-/utf8-2.1.0.tgz";
      name = "utf8-2.1.0.tgz";
      sha1 = "0cfec5c8052d44a23e3aaa908104e8075f95dfd5";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ws"."1.0.1" =
    self.by-version."ws"."1.0.1";
  by-version."ws"."1.0.1" = self.buildNodePackage {
    name = "ws-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ws/-/ws-1.0.1.tgz";
      name = "ws-1.0.1.tgz";
      sha1 = "7d0b2a2e58cddd819039c29c9de65045e1b310e9";
    };
    deps = {
      "options-0.0.6" = self.by-version."options"."0.0.6";
      "ultron-1.0.2" = self.by-version."ultron"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."xmlhttprequest-ssl"."1.5.1" =
    self.by-version."xmlhttprequest-ssl"."1.5.1";
  by-version."xmlhttprequest-ssl"."1.5.1" = self.buildNodePackage {
    name = "xmlhttprequest-ssl-1.5.1";
    version = "1.5.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/xmlhttprequest-ssl/-/xmlhttprequest-ssl-1.5.1.tgz";
      name = "xmlhttprequest-ssl-1.5.1.tgz";
      sha1 = "3b7741fea4a86675976e908d296d4445961faa67";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."yeast"."0.1.2" =
    self.by-version."yeast"."0.1.2";
  by-version."yeast"."0.1.2" = self.buildNodePackage {
    name = "yeast-0.1.2";
    version = "0.1.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/yeast/-/yeast-0.1.2.tgz";
      name = "yeast-0.1.2.tgz";
      sha1 = "008e06d8094320c372dbc2f8ed76a0ca6c8ac419";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
}
