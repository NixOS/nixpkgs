{ lib, stdenv
, fetchFromGitLab
, nix-update-script

, autoreconfHook
, pkg-config
, sphinx

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
}:

stdenv.mkDerivation rec {
  pname = "libtiff";
  version = "4.5.0";

  src = fetchFromGitLab {
    owner = "libtiff";
    repo = "libtiff";
    rev = "v${version}";
    hash = "sha256-KG6rB940JMjFUTAgtkzg+Zh75gylPY6Q7/4gEbL0Hcs=";
  };

  patches = [
    # FreeImage needs this patch
    ./headers.patch
    # libc++abi 11 has an `#include <version>`, this picks up files name
    # `version` in the project's include paths
    ./rename-version.patch
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

  propagatedBuildInputs = [ libjpeg xz zlib ]; #TODO: opengl support (bogus configure detection)

  buildInputs = [ libdeflate ];

  enableParallelBuilding = true;

  doCheck = true;

  passthru = {
    tests = {
      inherit libgeotiff imagemagick graphicsmagick gdal openimageio freeimage;
      inherit (python3Packages) pillow imread;
    };
    updateScript = nix-update-script { };
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
