{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "shhmsg-1.4.2";

  src = fetchurl {
    url = "http://shh.thathost.com/pub-unix/files/${name}.tar.gz";
    sha256 = "0ax02fzqpaxr7d30l5xbndy1s5vgg1ag643c7zwiw2wj1czrxil8";
  };

  installFlags = [ "INSTBASEDIR=$(out)" ];

  meta = with stdenv.lib; {
    description = "A library for displaying messages";
    homepage = http://shh.thathost.com/pub-unix/;
    license = licenses.artistic1;
    platforms = platforms.linux;
  };
}

