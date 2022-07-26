{ lib, stdenv
, fetchurl

, pkg-config
, cmake

, libdeflate
, libjpeg
, xz
, zlib
}:

stdenv.mkDerivation rec {
  pname = "libtiff";
  version = "4.2.0";

  src = fetchurl {
    url = "https://download.osgeo.org/libtiff/tiff-${version}.tar.gz";
    sha256 = "1jrkjv0xya9radddn8idxvs2gqzp3l2b1s8knlizmn7ad3jq817b";
  };

  # FreeImage needs this patch
  patches = [ ./headers-cmake.patch ];

  outputs = [ "bin" "dev" "dev_private" "out" "man" "doc" ];

  postFixup = ''
    moveToOutput include/tif_dir.h $dev_private
    moveToOutput include/tif_config.h $dev_private
    moveToOutput include/tiffiop.h $dev_private
  '';

  nativeBuildInputs = [ cmake pkg-config ];

  propagatedBuildInputs = [ libjpeg xz zlib ]; #TODO: opengl support (bogus configure detection)

  buildInputs = [ libdeflate ]; # TODO: move all propagatedBuildInputs to buildInputs.

  enableParallelBuilding = true;

  doInstallCheck = true;
  installCheckTarget = "test";

  meta = with lib; {
    description = "Library and utilities for working with the TIFF image file format";
    homepage = "https://libtiff.gitlab.io/libtiff";
    changelog = "https://libtiff.gitlab.io/libtiff/v${version}.html";
    license = licenses.libtiff;
    platforms = platforms.unix;
  };
}
