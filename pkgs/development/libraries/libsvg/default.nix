{ stdenv, fetchurl, pkgconfig, libpng, libjpeg, libxml2 }:

stdenv.mkDerivation rec {
  name = "libsvg-${version}";
  version = "0.1.4";

  buildInputs = [ pkgconfig libpng libjpeg libxml2 ]; 

  src = fetchurl {
      url = "http://cairographics.org/snapshots/libsvg-0.1.4.tar.gz";
      sha256 = "13xw0ka1wpzlpdzvds555rzwsf0g9pk1ns9q4fqp4sk75qlzjfsc";
  };
 
  meta = with stdenv.lib; {    
    description = "A library for parsing SVG files";
    homepage = http://cairographics.org/;
    license = with licenses; [ lgpl2Plus mpl10 ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ kisonecat ];
  };
}
