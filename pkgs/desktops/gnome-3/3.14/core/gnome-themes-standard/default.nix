{ stdenv, fetchurl, intltool, gtk3, gnome3, librsvg, pkgconfig, pango, atk, gtk2, gdk_pixbuf }:

stdenv.mkDerivation rec {
  name = "gnome-themes-standard-${gnome3.version}.2";
  src = fetchurl {
    url = "mirror://gnome/sources/gnome-themes-standard/${gnome3.version}/${name}.tar.xz";
    sha256 = "2fc21963bd8b65afff9a7f1b025035adc6d9db2810a134172c7a0155d81a7d28";
  };
  
  buildInputs = [ intltool gtk3 librsvg pkgconfig pango atk gtk2 gdk_pixbuf ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = [ maintainers.lethalman ];
  };
}
