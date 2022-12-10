{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "tecla";
  version = "1.6.3";

  src = fetchurl {
    url = "https://www.astro.caltech.edu/~mcs/tecla/libtecla-${version}.tar.gz";
    sha256 = "06pfq5wa8d25i9bdjkp4xhms5101dsrbg82riz7rz1a0a32pqxgj";
  };

  postPatch = ''
    substituteInPlace install-sh \
      --replace "stripprog=" "stripprog=\$STRIP # "
  '';

  meta = {
    description = "Command-line editing library";
    homepage = "https://www.astro.caltech.edu/~mcs/tecla/";
    license = "as-is";
    mainProgram = "enhance";
    platforms = lib.platforms.unix;
  };
}
