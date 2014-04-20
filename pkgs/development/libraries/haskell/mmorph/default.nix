{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "mmorph";
  version = "1.0.2";
  sha256 = "0d0nn5x7f3yyck10znqa13iihkshq04xgg1d9bn1nvl7kjzicjwh";
  buildDepends = [ transformers ];
  meta = {
    description = "Monad morphisms";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
