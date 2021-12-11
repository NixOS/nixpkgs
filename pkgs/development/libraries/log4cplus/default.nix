{ lib, stdenv, fetchurl }:

let
  name = "log4cplus-2.0.7";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://sourceforge/log4cplus/${name}.tar.bz2";
    sha256 = "sha256-j626/uK6TlWKD3iEJhPJ+yOcd12D8jNA0JEITA4bEqs=";
  };

  meta = {
    homepage = "http://log4cplus.sourceforge.net/";
    description = "A port the log4j library from Java to C++";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
}
