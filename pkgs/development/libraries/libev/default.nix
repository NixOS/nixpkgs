{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libev-${version}";
  version="4.20";

  src = fetchurl {
    url = "http://dist.schmorp.de/libev/Attic/${name}.tar.gz";
    sha256 = "17j47pbkr65a18mfvy2861p5k7w4pxmdgiw723ryfqd9gx636w7q";
  };

  meta = {
    description = "A high-performance event loop/event model with lots of features";
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.bsd2; # or GPL2+
  };
}
