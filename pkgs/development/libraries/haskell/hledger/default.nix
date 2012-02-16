{ cabal, cabalFileTh, cmdargs, csv, filepath, haskeline, hledgerLib
, HUnit, mtl, parsec, regexpr, safe, split, time, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hledger";
  version = "0.17";
  sha256 = "0ah01d10hvz12zwkprk6sb3by8azz9fhm772440arhd7r9fn6232";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    cabalFileTh cmdargs csv filepath haskeline hledgerLib HUnit mtl
    parsec regexpr safe split time utf8String
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
