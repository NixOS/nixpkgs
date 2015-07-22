{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name    = "concurrencykit-${version}";
  version = "0.4.5";

  src = fetchurl {
    url    = "http://concurrencykit.org/releases/ck-${version}.tar.gz";
    sha256 = "0mh3z8ibiwidc6qvrv8bx9slgcycxwy06kfngfzfza6nihrymzl9";
  };

  enableParallelBuilding = true;

  configurePhase = "./configure --prefix=$out";

  meta = {
    description = "A library of safe, high-performance concurrent data structures";
    homepage    = "http://concurrencykit.org";
    license     = stdenv.lib.licenses.bsd2;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
