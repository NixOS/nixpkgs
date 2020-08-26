{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "enet-1.3.15";

  src = fetchurl {
    url = "http://enet.bespin.org/download/${name}.tar.gz";
    sha256 = "1yxxf9bkx6dx3j8j70fj17c05likyfibb1419ls74hp58qrzdgas";
  };

  meta = {
    homepage = "http://enet.bespin.org/";
    description = "Simple and robust network communication layer on top of UDP";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ ];
    platforms = stdenv.lib.platforms.unix;
  };
}
