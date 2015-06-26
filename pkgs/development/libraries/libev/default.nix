{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libev-${version}";
  version="4.19";
  src = fetchurl {
    url = "http://dist.schmorp.de/libev/Attic/${name}.tar.gz";
    sha256 = "1jyw7qbl0spxqa0dccj9x1jsw7cj7szff43cq4acmklnra4mzz48";
  };

  patches = [ ./noreturn.patch ];

  # Version 4.19 is not valid C11 (which Clang default to)
  # Check if this is still necessary on upgrade
  NIX_CFLAGS_COMPILE = if stdenv.cc.isClang then "-std=c99" else null;

  meta = {
    description = "A high-performance event loop/event model with lots of features";
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.bsd2; # or GPL2+
  };
}
