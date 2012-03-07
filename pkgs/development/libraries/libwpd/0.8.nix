{ stdenv, fetchurl, pkgconfig, glib, libgsf, libxml2, bzip2 }:

stdenv.mkDerivation rec {
  name = "libwpd-0.8.14";
  
  src = fetchurl {
    url = "mirror://sourceforge/libwpd/${name}.tar.gz";
    sha256 = "1syli6i5ma10cwzpa61a18pyjmianjwsf6pvmvzsh5md6yk4yx01";
  };
  
  patches = [ ./gcc-0.8.patch ];

  buildInputs = [ glib libgsf libxml2 ];

  buildNativeInputs = [ pkgconfig bzip2 ];
}
