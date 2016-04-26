{ stdenv, fetchurl, xercesc }:

stdenv.mkDerivation rec {
  name = "xalan-c-${version}";
  version = "1.11";

  src = fetchurl {
    url = "http://www.eu.apache.org/dist/xalan/xalan-c/sources/xalan_c-${version}-src.tar.gz";
    sha256 = "0a3a2b15vpacnqgpp6fiy1pwyc8q6ywzvyb5445f6wixfdspypjg";
  };

  configurePhase = ''
    export XALANCROOT=`pwd`/c
    cd `pwd`/c
    mkdir -p $out/usr
    ./runConfigure -p linux -c gcc -x g++ -P$out/usr
  '';

  buildInputs = [ xercesc ];

  meta = {
    homepage = http://xalan.apache.org/;
    description = "A XSLT processor for transforming XML documents";
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.jagajaga ];
  };
}
