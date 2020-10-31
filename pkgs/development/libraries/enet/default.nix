{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "enet-1.3.16";

  src = fetchurl {
    url = "http://enet.bespin.org/download/${name}.tar.gz";
    sha256 = "1lggc82rbzscci057dqqyhkbq4j6mr5k01hbrvn06jkzc2xpxdxv";
  };

  meta = {
    homepage = "http://enet.bespin.org/";
    description = "Simple and robust network communication layer on top of UDP";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ ];
    platforms = stdenv.lib.platforms.unix;
  };
}
