{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name    = "concurrencykit-${version}";
  version = "0.4.3";

  src = fetchurl {
    url    = "http://concurrencykit.org/releases/ck-${version}.tar.gz";
    sha256 = "1fjdvbj6wazblg6qy0gdqs3kach2y2p6xrcvssmcvxr0nfyaadg2";
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
