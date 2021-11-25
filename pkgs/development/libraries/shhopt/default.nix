{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "shhopt";
  version = "1.1.7";

  src = fetchurl {
    url = "https://shh.thathost.com/pub-unix/files/${pname}-${version}.tar.gz";
    sha256 = "0yd6bl6qw675sxa81nxw6plhpjf9d2ywlm8a5z66zyjf28sl7sds";
  };

  postPatch = ''
    substituteInPlace Makefile --replace "gcc" "${stdenv.cc.targetPrefix}cc"
  '';

  installFlags = [ "INSTBASEDIR=$(out)" ];

  meta = with lib; {
    description = "A library for parsing command line options";
    homepage = "https://shh.thathost.com/pub-unix/";
    license = licenses.artistic1;
    platforms = platforms.all;
  };
}
