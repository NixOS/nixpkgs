{ stdenv, fetchurl, pkgconfig, libxml2, gtk, intltool, libsoup, gconf
, pango, gdk_pixbuf, atk }:

stdenv.mkDerivation rec {
  name = "libgweather-3.6.2";

  src = fetchurl {
    url = "mirror://gnome/sources/libgweather/3.6/${name}.tar.xz";
    sha256 = "1c50m0zrnfh4g58rzf33dfw8ggslj38c61p8a75905bmj3rfyahg";
  };
  configureFlags = if stdenv ? glibc then "--with-zoneinfo-dir=${stdenv.glibc}/share/zoneinfo" else "";
  propagatedBuildInputs = [ libxml2 gtk libsoup gconf pango gdk_pixbuf atk ];
  nativeBuildInputs = [ pkgconfig intltool ];
}
