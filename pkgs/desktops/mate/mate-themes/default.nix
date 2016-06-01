{ stdenv, fetchurl, pkgconfig, intltool, gtk2, gtk_engines,
gtk-engine-murrine, gdk_pixbuf, librsvg }:

stdenv.mkDerivation rec {
  name = "mate-themes-${version}";
  version = "${major-ver}.${minor-ver}";
  major-ver = "3.18";
  minor-ver = "1";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/themes/${major-ver}/${name}.tar.xz";
    sha256 = "0lkp6jqvnxp6jly35iw89paqs279nvhqg01ig92n1xcfp8yrqq9c";
  };

  nativeBuildInputs = [ pkgconfig intltool ];

  buildInputs = [ gtk2 gtk_engines gtk-engine-murrine gdk_pixbuf librsvg ];

  meta = {
    description = "A set of themes from MATE";
    homepage = "http://mate-desktop.org";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
