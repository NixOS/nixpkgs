{ stdenv, fetchurl, pkgconfig, glib, libgsf, libxml2, bzip2 }:

stdenv.mkDerivation {
  name = "libwpd-0.8.14";
  
  src = fetchurl {
    url = mirror://sourceforge/libwpd/libwpd-0.8.14.tar.gz;
    sha256 = "1syli6i5ma10cwzpa61a18pyjmianjwsf6pvmvzsh5md6yk4yx01";
  };
  
  buildInputs = [ pkgconfig glib libgsf libxml2 bzip2 ];
}
