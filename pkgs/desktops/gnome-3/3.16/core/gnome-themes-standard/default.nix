{ stdenv, fetchurl, intltool, gtk3, gnome3, librsvg, pkgconfig, pango, atk, gtk2
, gdk_pixbuf }:

stdenv.mkDerivation rec {
  name = "gnome-themes-standard-${gnome3.version}.0";
  src = fetchurl {
    url = "mirror://gnome/sources/gnome-themes-standard/${gnome3.version}/${name}.tar.xz";
    sha256 = "0kyrbfrgl6g6wm6zpllldz36fclvl8vwmn1snwk18kf7f6ncpsac";
  };
  
  buildInputs = [ intltool gtk3 librsvg pkgconfig pango atk gtk2 gdk_pixbuf
                  gnome3.defaultIconTheme ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
