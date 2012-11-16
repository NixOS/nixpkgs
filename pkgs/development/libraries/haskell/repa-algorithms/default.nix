{ cabal, llvm, repa, vector }:

cabal.mkDerivation (self: {
  pname = "repa-algorithms";
  version = "3.2.2.3";
  sha256 = "1maxkl7plxzdkmbak4c7qj68chbpkbarjmw454kjx544pbkn9xhb";
  buildDepends = [ repa vector ];
  extraLibraries = [ llvm ];
  jailbreak = true;
  meta = {
    homepage = "http://repa.ouroborus.net";
    description = "Algorithms using the Repa array library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
