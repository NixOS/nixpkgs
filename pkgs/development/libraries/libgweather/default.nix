{ stdenv, fetchurl, pkgconfig, libxml2, gtk3, intltool, libsoup, GConf3 }:

stdenv.mkDerivation {
  name = "libgweather-3.4.1";

  src = fetchurl {
    url = mirror://gnome/sources/libgweather/3.4/libgweather-3.4.1.tar.xz;
    sha256 = "0q0vkggrbvy2ihwcsfynlv5qk9l3wjinls8yvmkb1qisyc4lv77f";
  };
  configureFlags = if stdenv ? glibc then "--with-zoneinfo-dir=${stdenv.glibc}/share/zoneinfo" else "";
  propagatedBuildInputs = [ libxml2 gtk3 libsoup GConf3 ];
  nativeBuildInputs = [ pkgconfig intltool ];
}
