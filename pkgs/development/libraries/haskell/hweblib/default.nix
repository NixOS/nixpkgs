{ cabal, attoparsec, HUnit, mtl, text, transformers }:

cabal.mkDerivation (self: {
  pname = "hweblib";
  version = "0.6.3";
  sha256 = "03dmx5irlsyb3b9zg2r6nz947sslizkn0nlk65ldb5n4m8my33hy";
  buildDepends = [ attoparsec mtl text transformers ];
  testDepends = [ attoparsec HUnit mtl transformers ];
  meta = {
    homepage = "http://github.com/aycanirican/hweblib";
    description = "Haskell Web Library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
