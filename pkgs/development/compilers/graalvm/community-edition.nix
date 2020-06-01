{ stdenv
, lib
, callPackage
, darwin
, openjdk8
, python27
, fetchgit
, fetchurl
, fetchFromGitHub
, fetchpatch
}:
let
  sdkVersion = "20.0.0";
  makeMxCache = { depList, outputDir }: ''
    mkdir -p ${outputDir}
    ${lib.concatMapStrings
    ({ url, name, sha1 }: ''
      install -D ${fetchurl { inherit url sha1; }} ${outputDir}/${name}
      echo -n ${sha1} > ${outputDir}/${name}.sha1
    ''
    ) depList}
  '';
  makeMxGitCache = { depList, outputDir }: ''
    mkdir -p ${outputDir}
     ${lib.concatMapStrings
    ({ url, name, rev, sha256 }: ''
      mkdir -p ${outputDir}/${name}
      cp -rf ${fetchgit { inherit url rev sha256; }}/* ${outputDir}/${name}
    ''
    ) depList}
  '';
  graalVMSource = fetchFromGitHub {
    owner = "oracle";
    repo = "graal";
    rev = "release/graal-vm/20.0";
    sha256 = "0siwnhn260fyzcv22c9a7f3l69l1vzxxa73bnswr3q49vba4dlk4";
  };
  ninja-syntax = python27.pkgs.buildPythonPackage rec {
    version = "1.7.2";
    pname = "ninja_syntax";
    doCheck = false;
    src = python27.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "07zg30m0khx55fv2gxxn7pqd549z0vk3x592mrdlk9l8krxwjb9l";
    };
  };
  python27withPackages = python27.withPackages (ps: [ ninja-syntax ]);
  openjdk8Static = openjdk8.override { static = true; };
in
rec {
  graalvm8Packages = rec {
    majorVersion = 8;
    mx = callPackage ./ce/mx.nix { inherit python27withPackages; };
    jvmci8 = callPackage ./ce/jvmci8.nix {
      openjdk = openjdk8Static;
      inherit mx makeMxCache;
      inherit (darwin) libobjc;
      inherit (darwin.apple_sdk.frameworks)
        CoreFoundation Foundation JavaNativeFoundation
        JavaVM JavaRuntimeSupport Cocoa;
      # inherit libobjc CoreFoundation Foundation
      #   JavaNativeFoundation JavaRuntimeSupport JavaVM
      #   xcodebuild Cocoa
      # libresolv
      # inherit (darwin) libiconv libobjc;
    };
    sdk = callPackage ./ce/sdk.nix {
      inherit mx sdkVersion graalVMSource makeMxCache python27withPackages;
      jvmci = jvmci8;
    };
    graalpython = callPackage ./suites/graalpython/graalpython.nix {
      inherit sdkVersion;
      graalvm = sdk;
    };
    graaljs = callPackage ./suites/graaljs/graaljs.nix {
      inherit sdkVersion mx;
      graalvm = sdk;
    };
  };
}
