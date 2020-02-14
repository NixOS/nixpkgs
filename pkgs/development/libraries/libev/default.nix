{ stdenv, fetchurl, static ? false }:

stdenv.mkDerivation rec {
  pname = "libev";
  version="4.31";

  src = fetchurl {
    url = "http://dist.schmorp.de/libev/Attic/${pname}-${version}.tar.gz";
    sha256 = "0nkfqv69wfyy2bpga4d53iqydycpik8jp8x6q70353hia8mmv1gd";
  };

  configureFlags = stdenv.lib.optional (static) "LDFLAGS=-static";

  meta = {
    description = "A high-performance event loop/event model with lots of features";
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.bsd2; # or GPL2+
  };
}
