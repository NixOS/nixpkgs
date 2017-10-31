{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libltc-1.1.4";

  src = fetchurl {
    url = https://github.com/x42/libltc/releases/download/v1.1.4/libltc-1.1.4.tar.gz;
    sha256 = "0xas0zbi11nhq15al6cxn0iwa563s6fcz01hw0np1clh25h4773x";
  };

  meta = with stdenv.lib; {
    homepage = http://x42.github.io/libltc/;
    description = "POSIX-C Library for handling Linear/Logitudinal Time Code (LTC)";
    license = licenses.lgpl3Plus;
    platforms = platforms.all;
  };
}
