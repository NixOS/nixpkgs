{ cabal, ListLike, uuParsinglib }:

cabal.mkDerivation (self: {
  pname = "NanoProlog";
  version = "0.2.3.1";
  sha256 = "1pyvf1vmq61nhjg09416ap37c07lavrrgj2m9wx9dkyvhipzlxjv";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ ListLike uuParsinglib ];
  meta = {
    description = "Very small interpreter for a Prolog-like language";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
