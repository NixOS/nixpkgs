{ cabal, filepath, terminfo, transformers }:

cabal.mkDerivation (self: {
  pname = "haskeline";
  version = "0.7.0.3";
  sha256 = "10xc229ddk4g87i78vgjbfr7sii28fx00qwnggb5x7sfigfca8sg";
  buildDepends = [ filepath terminfo transformers ];
  configureFlags = "-fterminfo";
  meta = {
    homepage = "http://trac.haskell.org/haskeline";
    description = "A command-line interface for user input, written in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
