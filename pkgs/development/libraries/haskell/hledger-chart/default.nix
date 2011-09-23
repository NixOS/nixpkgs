{ cabal, Chart, cmdargs, colour, hledger, hledgerLib, HUnit, safe
, time
}:

cabal.mkDerivation (self: {
  pname = "hledger-chart";
  version = "0.15.2";
  sha256 = "1cs4m6lhpqib2rhpvyrw5319mjqw8cwlin7734m7yndjj8li8rcx";
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
