{ cabal, blazeBuilder, enumerator, transformers }:

cabal.mkDerivation (self: {
  pname = "blaze-builder-enumerator";
  version = "0.2.0.4";
  sha256 = "1zwp9hcjsmy5p5i436ajvl86zl1z4pzcfp6c57sj8vfr08rrrkq9";
  buildDepends = [ blazeBuilder enumerator transformers ];
  meta = {
    homepage = "https://github.com/meiersi/blaze-builder-enumerator";
    description = "Enumeratees for the incremental conversion of builders to bytestrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
