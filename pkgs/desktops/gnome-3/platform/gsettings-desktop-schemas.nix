{ stdenv, fetchurl, xz, glib, pkgconfig, intltool }:

stdenv.mkDerivation {
  name = "gsettings-desktop-schemas-3.2.0";

  src = fetchurl {
    url = mirror://gnome/sources/gsettings-desktop-schemas/3.2/gsettings-desktop-schemas-3.2.0.tar.xz;
    sha256 = "0772axkd1nlf3j1lcg0zi5x5jh4zmr25k98dhn7pzppahljaj3hi";
  };

  buildInputs = [ glib ];
  buildNativeInputs = [ pkgconfig xz intltool ];
}
