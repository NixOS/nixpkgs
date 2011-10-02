{ cabal, Chart, cmdargs, colour, hledger, hledgerLib, HUnit, safe
, time
}:

cabal.mkDerivation (self: {
  pname = "hledger-chart";
  version = "0.16";
  sha256 = "05njn30xxnjxigvz6sjhm1ks595f9y7ndw3il1grh09rhvgp42f7";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    Chart cmdargs colour hledger hledgerLib HUnit safe time
  ];
  meta = {
    homepage = "http://hledger.org";
    description = "A pie chart image generator for the hledger accounting tool";
    license = "GPL";
    platforms = self.stdenv.lib.platforms.linux;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
