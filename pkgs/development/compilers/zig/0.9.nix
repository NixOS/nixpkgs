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
  version = "0.9.1";

  hash = "sha256-x2c4c9RSrNWGqEngio4ArW7dJjW0gg+8nqBwPcR721k=";

  patches = [
    # Fix index out of bounds reading RPATH (cherry-picked from 0.10-dev)
    ./000-0.9-read-dynstr-at-rpath-offset.patch
    # Fix build on macOS 13 (cherry-picked from 0.10-dev)
    ./001-0.9-bump-macos-supported-version.patch
  ];

  prePatch =
    let
      zig_0_10_0 = fetchFromGitHub {
        owner = "ziglang";
        repo = "zig";
        rev = "0.10.0";
        hash = "sha256-DNs937N7PLQimuM2anya4npYXcj6cyH+dRS7AiOX7tw=";
      };
    in
    ''
      cp -R ${zig_0_10_0}/lib/libc/include/any-macos.13-any lib/libc/include/any-macos.13-any
      cp -R ${zig_0_10_0}/lib/libc/include/aarch64-macos.13-none lib/libc/include/aarch64-macos.13-gnu
      cp -R ${zig_0_10_0}/lib/libc/include/x86_64-macos.13-none lib/libc/include/x86_64-macos.13-gnu
      cp ${zig_0_10_0}/lib/libc/darwin/libSystem.13.tbd lib/libc/darwin/
    '';

  cmakeFlags = [
    # file RPATH_CHANGE could not write new RPATH
    "-DCMAKE_SKIP_BUILD_RPATH=ON"

    # ensure determinism in the compiler build
    "-DZIG_TARGET_MCPU=baseline"
  ];
}
