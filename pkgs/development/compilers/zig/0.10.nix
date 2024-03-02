{ lib
, stdenv
, fetchFromGitHub
, cmake
, llvmPackages
, libxml2
, zlib
, coreutils
, callPackage
}@args:

import ./generic.nix args {
  version = "0.10.1";

  hash = "sha256-69QIkkKzApOGfrBdgtmxFMDytRkSh+0YiaJQPbXsBeo=";

  outputs = [ "out" "doc" ];

  patches = [
    # Backport alignment related panics from zig-master to 0.10.
    # Upstream issue: https://github.com/ziglang/zig/issues/14559
    ./002-0.10-macho-fixes.patch
  ];

  cmakeFlags = [
    # file RPATH_CHANGE could not write new RPATH
    "-DCMAKE_SKIP_BUILD_RPATH=ON"

    # always link against static build of LLVM
    "-DZIG_STATIC_LLVM=ON"

    # ensure determinism in the compiler build
    "-DZIG_TARGET_MCPU=baseline"
  ];

  postBuild = ''
    ./zig2 run ../doc/docgen.zig -- ./zig2 ../doc/langref.html.in langref.html
  '';

  postInstall = ''
    install -Dm644 -t $doc/share/doc/zig-$version/html ./langref.html
  '';
}
