{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name    = "concurrencykit-${version}";
  version = "0.4.4";

  src = fetchurl {
    url    = "http://concurrencykit.org/releases/ck-${version}.tar.gz";
    sha256 = "0m3gzv5l7hw3zwhndjjvwmkhh66lvgnk0mspa2s12r1hlzc91zi3";
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
