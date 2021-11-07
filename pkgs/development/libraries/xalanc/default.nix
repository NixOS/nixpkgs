{ lib, stdenv, fetchurl, xercesc, getopt }:

let
  platform = if stdenv.isLinux then "linux" else
             if stdenv.isDarwin then "macosx" else
             throw "Unsupported platform";
in stdenv.mkDerivation rec {
  pname = "xalan-c";
  version = "1.11";

  src = fetchurl {
    url = "mirror://apache/xalan/xalan-c/sources/xalan_c-${version}-src.tar.gz";
    sha256 = "0a3a2b15vpacnqgpp6fiy1pwyc8q6ywzvyb5445f6wixfdspypjg";
  };

  configurePhase = ''
    export XALANCROOT=`pwd`/c
    cd `pwd`/c
    mkdir -p $out
    ./runConfigure -p ${platform} -c cc -x c++ -P$out
  '';

  buildInputs = [ xercesc getopt ];

  meta = {
    homepage = "http://xalan.apache.org/";
    description = "A XSLT processor for transforming XML documents";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = [ lib.maintainers.jagajaga ];
  };
}
