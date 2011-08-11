{ cabal, Chart, colour, hledger, hledgerLib, safe }:

cabal.mkDerivation (self: {
  pname = "hledger-chart";
  version = "0.14";
  sha256 = "fe321e4e31c72aef22945080323992a0033ae8fb48213ad7b708f86f9e2f6462";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ Chart colour hledger hledgerLib safe ];
  meta = {
    homepage = "http://hledger.org";
    description = "A pie chart generator for the hledger accounting tool";
    license = "GPL";
    platforms = self.stdenv.lib.platforms.linux;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
