{ stdenv, fetchurl, intltool, gtk3, librsvg, pkgconfig, pango, atk, gtk2, gdk_pixbuf }:

stdenv.mkDerivation rec {
  name = "gnome-themes-standard-3.12.0";
  src = fetchurl {
    url = "mirror://gnome/sources/gnome-themes-standard/3.12/${name}.tar.xz";
    sha256 = "a05d1b7ca872b944a69d0c0cc2369408ece32ff4355e37f8594a1b70d13c3217";
  };
  
  buildInputs = [ intltool gtk3 librsvg pkgconfig pango atk gtk2 gdk_pixbuf ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
