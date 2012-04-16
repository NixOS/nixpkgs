{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "explicit-exception";
  version = "0.1.7";
  sha256 = "0pqh97fxs55554bd16dknggkr0yayqj1dz0sddp9b2svjy2q4vrm";
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
