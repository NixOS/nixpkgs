{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libltc-1.3.0";

  src = fetchurl {
    url = https://github.com/x42/libltc/releases/download/v1.3.0/libltc-1.3.0.tar.gz;
    sha256 = "0p7fgp44i9d1lrgbk5zj3sm5yzavx428zn36xb3bl7y65c2xxcda";
  };

  meta = with stdenv.lib; {
    homepage = http://x42.github.io/libltc/;
    description = "POSIX-C Library for handling Linear/Logitudinal Time Code (LTC)";
    license = licenses.lgpl3Plus;
    platforms = platforms.all;
  };
}
