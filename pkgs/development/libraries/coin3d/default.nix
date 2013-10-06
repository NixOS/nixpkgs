{ fetchurl, stdenv, mesa }:

stdenv.mkDerivation rec {
  name = "coin3d-${version}";
  version = "3.1.3";

  src = fetchurl {
    url = "https://bitbucket.org/Coin3D/coin/downloads/Coin-${version}.tar.gz";
    sha256 = "05ylhrcglm81dajbk132l1w892634z2i97x10fm64y1ih72phd2q";
  };

  buildInputs = [ mesa ];

  meta = {
    homepage = http://www.coin3d.org/;
    license = "GPLv2+";
    description = "High-level, retained-mode toolkit for effective 3D graphics development";
    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.linux;
  };
}
