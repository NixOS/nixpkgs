{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libev";
  version="4.27";

  src = fetchurl {
    url = "http://dist.schmorp.de/libev/Attic/${pname}-${version}.tar.gz";
    sha256 = "0kil23cgsp0r5shvnwwbsy7fzxb62sxqzqbkbkfp5w54ipy2cm9d";
  };

  meta = {
    description = "A high-performance event loop/event model with lots of features";
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.bsd2; # or GPL2+
  };
}
