{ cabal, bifunctors, chunkedData, either, exceptions, filepath
, foldl, liftedAsync, liftedBase, mmorph, monadControl
, monoTraversable, mtl, mwcRandom, primitive, semigroups, stm
, streamingCommons, text, transformers, transformersBase, vector
, void
}:

cabal.mkDerivation (self: {
  pname = "simple-conduit";
  version = "0.4.0";
  sha256 = "0r9l0ms396gxkxgj1q33s0v8lim7rj77mhmf5k7wgf9mzydv1y6c";
  buildDepends = [
    bifunctors chunkedData either exceptions filepath foldl liftedAsync
    liftedBase mmorph monadControl monoTraversable mtl mwcRandom
    primitive semigroups stm streamingCommons text transformers
    transformersBase vector void
  ];
  meta = {
    homepage = "http://github.com/jwiegley/simple-conduit";
    description = "A simple streaming library based on composing monadic folds";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
