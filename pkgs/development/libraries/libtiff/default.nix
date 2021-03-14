{ lib, stdenv
, fetchurl

, pkg-config
, cmake

, zlib
, libjpeg
, xz
}:

stdenv.mkDerivation rec {
  version = "4.1.0";
  pname = "libtiff";

  src = fetchurl {
    url = "https://download.osgeo.org/libtiff/tiff-${version}.tar.gz";
    sha256 = "0d46bdvxdiv59lxnb0xz9ywm8arsr6xsapi5s6y6vnys2wjz6aax";
  };

  cmakeFlags = if stdenv.isDarwin then [
    "-DCMAKE_SKIP_BUILD_RPATH=OFF"
  ] else null;

  # FreeImage needs this patch
  patches = [ ./headers.patch ];

  outputs = [ "bin" "dev" "dev_private" "out" "man" "doc" ];

  postFixup = ''
    moveToOutput include/tif_dir.h $dev_private
    moveToOutput include/tif_config.h $dev_private
    moveToOutput include/tiffiop.h $dev_private
  '';

  nativeBuildInputs = [ cmake pkg-config ];

  propagatedBuildInputs = [ zlib libjpeg xz ]; #TODO: opengl support (bogus configure detection)

  enableParallelBuilding = true;

  doInstallCheck = true;
  installCheckTarget = "test";

  meta = with lib; {
    description = "Library and utilities for working with the TIFF image file format";
    homepage = "http://download.osgeo.org/libtiff";
    license = licenses.libtiff;
    platforms = platforms.unix;
  };
}
