{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libev-${version}";
  version="4.19";
  src = fetchurl {
    url = "http://dist.schmorp.de/libev/${name}.tar.gz";
    sha256 = "1jyw7qbl0spxqa0dccj9x1jsw7cj7szff43cq4acmklnra4mzz48";
  };
  meta = {
    description = "A high-performance event loop/event model with lots of features";
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.bsd2; # or GPL2+
  };
}
