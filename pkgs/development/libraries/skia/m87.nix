{ lib, callPackage, fetchgit, gn }:

(callPackage ./generic.nix {
  version = "m87";
  rev = "b95f800a2cc333528cab2e5fd4047b3539729e8a";  # chrome/m87 branch
  hash = "sha256-PXBilKdU4/PWwwBdk0x4tMkAkz1yMrDMPZQBYCmEjao=";
  depSrcs = import ./skia-deps-m87.nix { inherit fetchgit; };
  extraHeaders = [
    "src/sksl/SkSLExternalValue.h"
  ];
}).overrideAttrs (oldAttrs: {
  patches = (oldAttrs.patches or [ ]) ++ [
    # Fixes compilation on GCC 12
    # https://chromium.googlesource.com/skia/+/cd397f3c4738beb61cfd1c611544d096a6f4fa36
    ./skia-m87-gcc12.patch
  ];
})
