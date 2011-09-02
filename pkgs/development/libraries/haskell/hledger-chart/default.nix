{ cabal, Chart, cmdargs, colour, hledger, hledgerLib, HUnit, safe
, time
}:

cabal.mkDerivation (self: {
  pname = "hledger-chart";
  version = "0.15";
  sha256 = "03i09fsf1h7w62as6d3q4f7fadjykbhbi95jbv0scb67rb0g9cw1";
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
