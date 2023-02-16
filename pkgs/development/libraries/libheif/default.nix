{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
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
  version = "1.14.2";

  outputs = [ "bin" "out" "dev" "man" ];

  src = fetchFromGitHub {
    owner = "strukturag";
    repo = "libheif";
    rev = "v${version}";
    sha256 = "sha256-JwPeSNUc++z6RfMe0qAuXdekzLWR/MCmsT+Ykvp9a/s=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
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

  enableParallelBuilding = true;

  # Fix installation path for gdk-pixbuf module
  PKG_CONFIG_GDK_PIXBUF_2_0_GDK_PIXBUF_MODULEDIR = "${placeholder "out"}/${gdk-pixbuf.moduleDir}";

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
