{ stdenv, fetchurl, libxml2, curl }:

stdenv.mkDerivation rec {
  name = "raptor-1.4.21";

  src = fetchurl {
    url = "http://download.librdf.org/source/${name}.tar.gz";
    sha256 = "db3172d6f3c432623ed87d7d609161973d2f7098e3d2233d0702fbcc22cfd8ca";
  };

  buildInputs = [ libxml2 curl ];

  preBuild = ''
    sed -e '/curl\/types/d' -i src/*.c src/*.h
  '';

  meta = { 
    description = "The RDF Parser Toolkit";
    homepage = "http://librdf.org/raptor";
    license = "LGPL-2.1 Apache-2.0";
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
