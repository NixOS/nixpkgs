{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libltc-1.3.1";

  src = fetchurl {
    url = https://github.com/x42/libltc/releases/download/v1.3.1/libltc-1.3.1.tar.gz;
    sha256 = "173h9dgmain3nyrwk6q2d7yl4fnh4vacag4s2p01n5b7nyrkxrjh";
  };

  meta = with stdenv.lib; {
    homepage = http://x42.github.io/libltc/;
    description = "POSIX-C Library for handling Linear/Logitudinal Time Code (LTC)";
    license = licenses.lgpl3Plus;
    platforms = platforms.all;
  };
}
