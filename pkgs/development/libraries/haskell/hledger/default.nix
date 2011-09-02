{ cabal, cmdargs, csv, haskeline, hledgerLib, HUnit, mtl, parsec
, regexpr, safe, split, time, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hledger";
  version = "0.15";
  sha256 = "0pb5qm22x8wbw43199jn67qc6q5sbbwc3vrpxl1k9blxdnj4min0";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    cmdargs csv haskeline hledgerLib HUnit mtl parsec regexpr safe
    split time utf8String
  ];
  meta = {
    homepage = "http://hledger.org";
    description = "The main command-line interface for the hledger accounting tool";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
