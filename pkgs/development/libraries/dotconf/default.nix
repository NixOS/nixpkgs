{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "dotconf-" + version;
  version = "1.0.13";

  src = fetchurl {
    url = "http://www.azzit.de/dotconf/download/v1.0/dotconf-1.0.13.tar.gz";
    sha256 = "0rcvi743jgnrq2p5gknnvsqiv47479y5gyc2g9pz7bp7v7bzlmc9";
  };

  meta = {
    description = "A configuration parser library";

    homepage = http://www.azzit.de/dotconf/;
    license = stdenv.lib.licenses.lgpl21Plus;
  };
}
