{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "enet-1.3.13";

  src = fetchurl {
    url = "http://enet.bespin.org/download/${name}.tar.gz";
    sha256 = "0p53mnmjbm56wizwraznynx13fcibcxiqny110dp6a5a3w174q73";
  };

  meta = {
    homepage = http://enet.bespin.org/;
    description = "Simple and robust network communication layer on top of UDP";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
    platforms = stdenv.lib.platforms.linux;
  };
}
