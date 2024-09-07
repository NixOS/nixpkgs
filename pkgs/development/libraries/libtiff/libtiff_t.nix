{ lib
, stdenv
, fetchzip

, autoreconfHook
, pkg-config
, sphinx

, libdeflate
, libjpeg
, xz
, zlib
}:

# This is a fork created by the hylafaxplus developer to
# restore tools dropped by original libtiff in version 4.6.0.

stdenv.mkDerivation (finalAttrs: {
  pname = "libtiff_t";
  version = "4.6.0t";

  src = fetchzip {
    url = "http://www.libtiff.org/downloads/tiff-${finalAttrs.version}.tar.xz";
    hash = "sha256-9ov4w2jw4LtKr82/4jWMAGhc5GEdviJ7bT+y0+U/Ac4=";
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

  # TODO: opengl support (bogus configure detection)
  propagatedBuildInputs = [
    libdeflate
    libjpeg
    xz
    zlib
  ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = with lib; {
    description = "Library and utilities for working with the TIFF image file format (fork containing tools dropped in original libtiff version)";
    homepage = "http://www.libtiff.org";
    changelog = "http://www.libtiff.org/releases/v${finalAttrs.version}.html";
    maintainers = with maintainers; [ yarny ];
    license = licenses.libtiff;
    platforms = platforms.unix ++ platforms.windows;
    pkgConfigModules = [ "libtiff-4" ];
  };
})
