{ cabal, ListLike, uuParsinglib }:

cabal.mkDerivation (self: {
  pname = "NanoProlog";
  version = "0.2.3.3";
  sha256 = "0008xpahqbs2djchlw1bslhqqhbc0n7ql7pqm4g7lh8xd3ampxba";
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
