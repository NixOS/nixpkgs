{ cabal, hashable, liftedBase, ReadArgs, safe, systemFilepath, text
, transformers, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "basic-prelude";
  version = "0.3.6.0";
  sha256 = "1sm89mva8vkhqp230g965b0k4n3g0c8w4sfsad8m1wh434g3k732";
  buildDepends = [
    hashable liftedBase ReadArgs safe systemFilepath text transformers
    unorderedContainers vector
  ];
  meta = {
    homepage = "https://github.com/snoyberg/basic-prelude";
    description = "An enhanced core prelude; a common foundation for alternate preludes";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
