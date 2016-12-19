{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libev-${version}";
  version="4.22";

  src = fetchurl {
    url = "http://dist.schmorp.de/libev/Attic/${name}.tar.gz";
    sha256 = "1mhvy38g9947bbr0n0hzc34zwfvvfd99qgzpkbap8g2lmkl7jq3k";
  };

  meta = {
    description = "A high-performance event loop/event model with lots of features";
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.bsd2; # or GPL2+
  };
}
