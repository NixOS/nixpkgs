{ callPackage, fetchpatch }:

((callPackage ./generic.nix { }) {
  version = "0.6.1";
  hash = "sha256-DwIzyLC51zQpoqZC2yJ5RMuODkQVSPROOXnUpIccdJE=";
}).overrideAttrs
  (finalAttrs: {
    # Fix pkgconfig with absolute CMAKE_INSTALL_*DIR
    patches = [
      (fetchpatch {
        url = "https://github.com/gazebosim/gz-cmake/commit/fe3100f11073a82a8faf63eb629de9f77fe2b331.patch";
        hash = "sha256-fgSAOZoQmZt/nAx2eBDyC+4+0m++crlZ2BGRH4UcuQY=";
      })
    ];
  })
