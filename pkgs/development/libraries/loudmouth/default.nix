{stdenv, fetchurl, gnutls, libidn, glib, pkgconfig, zlib}:

stdenv.mkDerivation {
  name = "loudmouth-1.4.3";
    
  src = fetchurl {
    url = http://ftp.gnome.org/pub/GNOME/sources/loudmouth/1.4/loudmouth-1.4.3.tar.bz2;
    md5 = "55339ca42494690c3942ee1465a96937";
  };
    
  propagatedBuildInputs = [gnutls libidn glib zlib];
  
  buildInputs = [pkgconfig];
}
