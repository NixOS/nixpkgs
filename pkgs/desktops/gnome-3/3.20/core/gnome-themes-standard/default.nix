{ stdenv, fetchurl, intltool, gtk3, gnome3, librsvg, pkgconfig, pango, atk, gtk2
, gdk_pixbuf }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;
  
  buildInputs = [ intltool gtk3 librsvg pkgconfig pango atk gtk2 gdk_pixbuf
                  gnome3.defaultIconTheme ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
