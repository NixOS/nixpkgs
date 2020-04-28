{ stdenv
, Cocoa
, CoreFoundation
, Foundation
, JavaNativeFoundation
, JavaRuntimeSupport
, JavaVM
, bash
, bzip2
, clang
, curl
, ed
, fetchFromGitHub
, fetchgit
, fetchurl
, fetchzip
, gcc
, gfortran
, git
, glibc
, icu
, lib
, libiconv
, libobjc
, libresolv
, llvm
, lzma
, makeWrapper
, mercurial_4
, newScope
, ninja
, openjdk8
, openjdk11
, openssl
, pcre
, perl
, python27
, readline
, ruby
, rsync
, setJavaClassPath
, unzip
, which
, writeScriptBin
, xcodebuild
, zlib
, pkgs
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
  # https://github.com/graalvm/openjdk8-jvmci-builder/issues/11#issuecomment-542195999
  # openjdk8Static = openjdk8.override { static = true; };
  callPackageGraal8 = newScope ({
    openjdk = openjdk8.override { static = true; };
    inherit stdenv sdkVersion fetchFromGitHub
      makeMxCache makeMxGitCache graalVMSource
      python27withPackages;
  }
  );
in
rec {
  graalvm8Packages = rec {
    mx = callPackageGraal8 ./ce/mx.nix {
      inherit makeWrapper fetchzip;
    };
    jvmci = callPackageGraal8 ./ce/jvmci8.nix {
      inherit mx setJavaClassPath;
      inherit libobjc CoreFoundation Foundation
        JavaNativeFoundation JavaRuntimeSupport JavaVM
        xcodebuild Cocoa;
    };
    sdk = callPackageGraal8 ./ce/sdk.nix {
      inherit jvmci mx clang ninja mercurial_4 bash;
    };
  };
}
