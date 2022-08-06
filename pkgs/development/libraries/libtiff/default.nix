{ lib, stdenv
, fetchurl
, fetchpatch

, autoreconfHook
, pkg-config

, libdeflate
, libjpeg
, xz
, zlib

# for passthru.tests
, libgeotiff
, python3Packages
, imagemagick
, graphicsmagick
, gdal
, openimageio
, freeimage
, imlib
}:

stdenv.mkDerivation rec {
  pname = "libtiff";
  version = "4.4.0";

  src = fetchurl {
    url = "https://download.osgeo.org/libtiff/tiff-${version}.tar.gz";
    sha256 = "1vdbk3sc497c58kxmp02irl6nqkfm9rjs3br7g59m59qfnrj6wli";
  };

  patches = [
    # FreeImage needs this patch
    ./headers.patch
    # libc++abi 11 has an `#include <version>`, this picks up files name
    # `version` in the project's include paths
    ./rename-version.patch
    (fetchpatch {
      name = "CVE-2022-34526.patch";
      url = "https://gitlab.com/libtiff/libtiff/-/commit/275735d0354e39c0ac1dc3c0db2120d6f31d1990.patch";
      sha256 = "sha256-faKsdJjvQwNdkAKjYm4vubvZvnULt9zz4l53zBFr67s=";
    })
  ];

  postPatch = ''
    mv VERSION VERSION.txt
  '';

  outputs = [ "bin" "dev" "dev_private" "out" "man" "doc" ];

  postFixup = ''
    moveToOutput include/tif_dir.h $dev_private
    moveToOutput include/tif_config.h $dev_private
    moveToOutput include/tiffiop.h $dev_private
  '';

  # If you want to change to a different build system, please make
  # sure cross-compilation works first!
  nativeBuildInputs = [ autoreconfHook pkg-config ];

  propagatedBuildInputs = [ libjpeg xz zlib ]; #TODO: opengl support (bogus configure detection)

  buildInputs = [ libdeflate ];

  enableParallelBuilding = true;

  doCheck = true;

  passthru.tests = {
    inherit libgeotiff imagemagick graphicsmagick gdal openimageio freeimage imlib;
    inherit (python3Packages) pillow imread;
  };

  meta = with lib; {
    description = "Library and utilities for working with the TIFF image file format";
    homepage = "https://libtiff.gitlab.io/libtiff";
    changelog = "https://libtiff.gitlab.io/libtiff/v${version}.html";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.libtiff;
    platforms = platforms.unix;
  };
}
