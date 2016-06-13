{ stdenv, fetchurl, pkgconfig, intltool, mate, gnome3, gtk2, gtk_engines,
gtk-engine-murrine, gdk_pixbuf, librsvg }:

stdenv.mkDerivation rec {
  name = "mate-themes-${version}";
  version = "${major-ver}.${minor-ver}";
  major-ver = gnome3.version;
  minor-ver = {
    "3.18" = "2";
    "3.20" = "8";
  }."${major-ver}";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/themes/${major-ver}/${name}.tar.xz";
    sha256 = {
      "3.18" = "1yy22nk450wsx0mlsvdalkyj41mijlvy8s6kifh98d4dnk8dvgfj";
      "3.20" = "14jl3mbhzm7k2ilp8nmdwy9wrbmc7mbg2i0arf479xs2h7dz06f6";
    }."${major-ver}";
  };

  nativeBuildInputs = [ pkgconfig intltool ];

  buildInputs = [ mate.mate-icon-theme gtk2 gtk_engines gtk-engine-murrine
  gdk_pixbuf librsvg ];

  meta = {
    description = "A set of themes from MATE";
    homepage = "http://mate-desktop.org";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
