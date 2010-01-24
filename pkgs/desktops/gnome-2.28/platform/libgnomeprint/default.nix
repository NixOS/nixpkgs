{stdenv, fetchurl, pkgconfig, gtk, gettext, libxml2, intltool, libart_lgpl, libgnomecups, bison,
flex }:

stdenv.mkDerivation {
  name = "libgnomeprint-2.11.1";
  
  src = fetchurl {
    url = mirror://gnome/sources/libgnomeprint/2.18/libgnomeprint-2.18.6.tar.bz2;
    sha256 = "15c00ya2mx0x4mh8lyy3xg9dd66z5yjnax74bqx99zd90sar10fg";
  };
  
  buildInputs = [ pkgconfig gtk gettext intltool libart_lgpl libgnomecups bison flex ];
  propagatedBuildInputs = [ libxml2 ];
}
