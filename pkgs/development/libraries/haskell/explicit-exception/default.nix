{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "explicit-exception";
  version = "0.1.7.1";
  sha256 = "15p5pndam6byd3p8qlnn8pjdhb7rvn93fxa2m40x3wxh58ymkh14";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ transformers ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Exception";
    description = "Exceptions which are explicit in the type signature";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
