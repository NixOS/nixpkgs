{ lib
, stdenv
, fetchFromGitLab
, fetchpatch
, nix-update-script

, autoreconfHook
, pkg-config
, sphinx

, lerc
, libdeflate
, libjpeg
, libwebp
, xz
, zlib
, zstd

  # for passthru.tests
, libgeotiff
, python3Packages
, imagemagick
, graphicsmagick
, gdal
, openimageio
, freeimage
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libtiff";
  version = "4.6.0";

  src = fetchFromGitLab {
    owner = "libtiff";
    repo = "libtiff";
    rev = "v${finalAttrs.version}";
    hash = "sha256-qCg5qjsPPynCHIg0JsPJldwVdcYkI68zYmyNAKUCoyw=";
  };

  patches = [
    # FreeImage needs this patch
    ./headers.patch
    # libc++abi 11 has an `#include <version>`, this picks up files name
    # `version` in the project's include paths
    ./rename-version.patch
    # Fix static linking of `libtiff` via `pkg-config` not working
    # because `libtiff` does not declare `Lerc` dependency.
    # nixpkgs has `lerc` >= 4 which provides a `.pc` file.
    # TODO: Close when https://gitlab.com/libtiff/libtiff/-/merge_requests/633 is merged and available
    (fetchpatch {
      name = "libtiff-4.pc-Fix-Requires.private-missing-Lerc.patch";
      url = "https://gitlab.com/libtiff/libtiff/-/commit/ea882c3c240c14a897b9be38d815cc1893aafa59.patch";
      hash = "sha256-C0xA3k1sgKmGJjEnyG9UxhXqYBYShKUDQsyjhbEDJbQ=";
    })
  ];

  postPatch = ''
    mv VERSION VERSION.txt
  '';

  outputs = [ "bin" "dev" "dev_private" "out" "man" "doc" ];

  postFixup = ''
    moveToOutput include/tif_config.h $dev_private
    moveToOutput include/tif_dir.h $dev_private
    moveToOutput include/tif_hash_set.h $dev_private
    moveToOutput include/tiffiop.h $dev_private
  '';

  # If you want to change to a different build system, please make
  # sure cross-compilation works first!
  nativeBuildInputs = [ autoreconfHook pkg-config sphinx ];

  buildInputs = [
    lerc
    zstd
  ];

  # TODO: opengl support (bogus configure detection)
  propagatedBuildInputs = [
    libdeflate
    libjpeg
    # libwebp depends on us; this will cause infinite
    # recursion otherwise
    (libwebp.override { tiffSupport = false; })
    xz
    zlib
    zstd
  ];

  enableParallelBuilding = true;

  doCheck = true;

  passthru = {
    tests = {
      inherit libgeotiff imagemagick graphicsmagick gdal openimageio freeimage;
      inherit (python3Packages) pillow imread;
      pkg-config = testers.hasPkgConfigModules {
        package = finalAttrs.finalPackage;
      };
    };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Library and utilities for working with the TIFF image file format";
    homepage = "https://libtiff.gitlab.io/libtiff";
    changelog = "https://libtiff.gitlab.io/libtiff/releases/v${finalAttrs.version}.html";
    license = licenses.libtiff;
    platforms = platforms.unix ++ platforms.windows;
    pkgConfigModules = [ "libtiff-4" ];
    maintainers = teams.geospatial.members;
  };
})
