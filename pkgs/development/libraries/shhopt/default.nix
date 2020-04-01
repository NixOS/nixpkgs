{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "shhopt-1.1.7";

  src = fetchurl {
    url = "https://shh.thathost.com/pub-unix/files/${name}.tar.gz";
    sha256 = "0yd6bl6qw675sxa81nxw6plhpjf9d2ywlm8a5z66zyjf28sl7sds";
  };

  installFlags = [ "INSTBASEDIR=$(out)" ];

  meta = with stdenv.lib; {
    description = "A library for parsing command line options";
    homepage = https://shh.thathost.com/pub-unix/;
    license = licenses.artistic1;
    platforms = platforms.linux;
  };
}
