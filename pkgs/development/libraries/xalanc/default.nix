{ stdenv, fetchurl, xercesc, getopt }:

let
  platform = if stdenv.isLinux then "linux" else
             if stdenv.isDarwin then "macosx" else
             throw "Unsupported platform";
in stdenv.mkDerivation rec {
  name = "xalan-c-${version}";
  version = "1.11";

  src = fetchurl {
    url = "http://www.eu.apache.org/dist/xalan/xalan-c/sources/xalan_c-${version}-src.tar.gz";
    sha256 = "0a3a2b15vpacnqgpp6fiy1pwyc8q6ywzvyb5445f6wixfdspypjg";
  };

  # TODO: should we really be putting outputs in $out/usr? I'd expect -P$out below
  configurePhase = ''
    export XALANCROOT=`pwd`/c
    cd `pwd`/c
    mkdir -p $out/usr
    ./runConfigure -p ${platform} -c cc -x c++ -P$out/usr
  '';

  buildInputs = [ xercesc getopt ];

  meta = {
    homepage = http://xalan.apache.org/;
    description = "A XSLT processor for transforming XML documents";
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    maintainers = [ stdenv.lib.maintainers.jagajaga ];
  };
}
