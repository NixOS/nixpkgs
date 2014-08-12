{ stdenv, fetchurl, intltool, gtk3, librsvg, pkgconfig, pango, atk, gtk2, gdk_pixbuf }:

stdenv.mkDerivation rec {
  name = "gnome-themes-standard-3.10.0";
  src = fetchurl {
    url = "mirror://gnome/sources/gnome-themes-standard/3.10/${name}.tar.xz";
    sha256 = "0f2b3ypkfvrdsxcvp14ja9wqj382f1p46yrjvhhxkkjgagy6qb41";
  };
  
  buildInputs = [ intltool gtk3 librsvg pkgconfig pango atk gtk2 gdk_pixbuf ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
