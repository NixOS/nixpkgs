{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "mmorph";
  version = "1.0.3";
  sha256 = "0b8pzb63zxw3cjw8yj73swvqhmi9c4lgw1mis1xbraya7flxc6qm";
  buildDepends = [ transformers ];
  meta = {
    description = "Monad morphisms";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
