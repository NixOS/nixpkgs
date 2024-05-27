{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, dav1d
, rav1e
, libde265
, x265
, libpng
, libjpeg
, libaom
, gdk-pixbuf

# for passthru.tests
, gimp
, imagemagick
, imlib2Full
, imv
, vips
}:

stdenv.mkDerivation rec {
  pname = "libheif";
  version = "1.17.6";

  outputs = [ "bin" "out" "dev" "man" ];

  src = fetchFromGitHub {
    owner = "strukturag";
    repo = "libheif";
    rev = "v${version}";
    sha256 = "sha256-pp+PjV/pfExLqzFE61mxliOtVAYOePh1+i1pwZxDLAM=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [
    dav1d
    rav1e
    libde265
    x265
    libpng
    libjpeg
    libaom
    gdk-pixbuf
  ];

  # Fix installation path for gdk-pixbuf module
  PKG_CONFIG_GDK_PIXBUF_2_0_GDK_PIXBUF_MODULEDIR = "${placeholder "out"}/${gdk-pixbuf.moduleDir}";

  # Wrong include path in .cmake.  It's a bit difficult to patch because of special characters.
  postFixup = ''
    sed '/^  INTERFACE_INCLUDE_DIRECTORIES/s|"[^"]*/include"|"${placeholder "dev"}/include"|' \
      -i "$dev"/lib/cmake/libheif/libheif-config.cmake
  '';

  passthru.tests = {
    inherit gimp imagemagick imlib2Full imv vips;
  };

  meta = {
    homepage = "http://www.libheif.org/";
    description = "ISO/IEC 23008-12:2017 HEIF image file format decoder and encoder";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ gebner ];
  };
}
