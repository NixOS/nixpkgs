{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "tecla-1.6.3";

  src = fetchurl {
    url = "https://www.astro.caltech.edu/~mcs/tecla/lib${name}.tar.gz";
    sha256 = "06pfq5wa8d25i9bdjkp4xhms5101dsrbg82riz7rz1a0a32pqxgj";
  };

  postPatch = ''
    substituteInPlace install-sh \
      --replace "stripprog=" "stripprog=\$STRIP # "
  '';

  meta = {
    homepage = "https://www.astro.caltech.edu/~mcs/tecla/";
    description = "Command-line editing library";
    license = "as-is";

    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.peti ];
  };
}
