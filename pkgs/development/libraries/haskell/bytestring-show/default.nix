{ cabal, binary }:

cabal.mkDerivation (self: {
  pname = "bytestring-show";
  version = "0.3.5.5";
  sha256 = "0vd8f3jrzi2s119rcn20k6srk6l7ypiars1mxw1n1jrjx8ill2y4";
  buildDepends = [ binary ];
  meta = {
    homepage = "http://code.haskell.org/~dolio/";
    description = "Efficient conversion of values into readable byte strings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
