{stdenv, fetchurl, openssl, libidn, glib, pkgconfig, zlib}:

stdenv.mkDerivation {
  name = "loudmouth-1.4.3";
    
  src = fetchurl {
    url = mirror://gnome/sources/loudmouth/1.4/loudmouth-1.4.3.tar.bz2;
    md5 = "55339ca42494690c3942ee1465a96937";
  };
    
  configureFlags = "--with-ssl=openssl";
  
  propagatedBuildInputs = [openssl libidn glib zlib];
  
  buildInputs = [pkgconfig];
}
