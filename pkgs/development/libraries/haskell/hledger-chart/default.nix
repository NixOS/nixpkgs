{ cabal, Chart, cmdargs, colour, hledger, hledgerLib, HUnit, safe
, time
}:

cabal.mkDerivation (self: {
  pname = "hledger-chart";
  version = "0.15.1";
  sha256 = "1sb48ajc4fg2xin7nd35kwd3rqg4zg2318mgwqld8l0xv77jv5fh";
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
