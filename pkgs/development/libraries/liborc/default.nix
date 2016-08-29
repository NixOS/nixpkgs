{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "liborc-${version}";
  version = "0.4.16";

  src = fetchurl {
    url = "http://http.debian.net/debian/pool/main/o/orc/orc_${version}.orig.tar.gz";
    sha256 = "1asq58gm87ig60ib4cs69hyqhnsirqkdlidnchhx83halbdlw3kh";
  };

  meta = with stdenv.lib; {
    homepage = https://packages.debian.org/wheezy/liborc-0.4-0;
    description = "Orc is a library and set of tools for compiling and executing very simple programs that operate on arrays of data.";
    license = with licenses; [ bsd2 bsd3 ];
  };
}
