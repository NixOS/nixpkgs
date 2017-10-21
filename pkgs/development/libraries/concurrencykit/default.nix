{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name    = "concurrencykit-${version}";
  version = "0.6.0";

  src = fetchurl {
    url    = "http://concurrencykit.org/releases/ck-${version}.tar.gz";
    sha256 = "1pv21p7sjwwmbs2xblpy1lqk53r2i212yrqyjlr5dr3rlv87vqnp";
  };
  
  #Deleting this line causes "Unknown option --disable-static"
  configurePhase = "./configure --prefix=$out";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A library of safe, high-performance concurrent data structures";
    homepage    = http://concurrencykit.org;
    license     = licenses.bsd2;
    platforms   = platforms.unix;
    maintainers = [ maintainers.thoughtpolice ];
  };
}
