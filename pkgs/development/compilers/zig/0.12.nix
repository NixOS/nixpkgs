{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  llvmPackages,
  libxml2,
  zlib,
  coreutils,
  callPackage,
}@args:

import ./generic.nix args {
  version = "0.12.0";

  hash = "sha256-RNZiUZtaKXoab5kFrDij6YCAospeVvlLWheTc3FGMks=";

  outputs = [
    "out"
    "doc"
  ];

  cmakeFlags = [
    # file RPATH_CHANGE could not write new RPATH
    (lib.cmakeBool "CMAKE_SKIP_BUILD_RPATH" true)

    # always link against static build of LLVM
    (lib.cmakeBool "ZIG_STATIC_LLVM" true)

    # ensure determinism in the compiler build
    (lib.cmakeFeature "ZIG_TARGET_MCPU" "baseline")
  ];

  postBuild = ''
    stage3/bin/zig run ../tools/docgen.zig -- ../doc/langref.html.in langref.html --zig $PWD/stage3/bin/zig
  '';

  postInstall = ''
    install -Dm444 langref.html -t $doc/share/doc/zig-$version/html
  '';
}
