{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "tecla-1.6.3";

  src = fetchurl {
    url = "http://www.astro.caltech.edu/~mcs/tecla/lib${name}.tar.gz";
    sha256 = "06pfq5wa8d25i9bdjkp4xhms5101dsrbg82riz7rz1a0a32pqxgj";
  };

  meta = {
    homepage = http://www.astro.caltech.edu/~mcs/tecla/;
    description = "Command-line editing library";
    license = "as-is";

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.peti ];
  };
}
