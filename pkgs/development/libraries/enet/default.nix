{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "enet-1.3.12";

  src = fetchurl {
    url = "http://enet.bespin.org/download/${name}.tar.gz";
    sha256 = "02qxgsn20m306hg3pklfa35mjlc2fqcsd1x4pi3xnbfy1nyir1d5";
  };

  meta = {
    homepage = http://enet.bespin.org/;
    description = "Simple and robust network communication layer on top of UDP";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
