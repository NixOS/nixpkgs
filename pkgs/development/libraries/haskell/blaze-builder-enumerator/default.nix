{ cabal, blazeBuilder, enumerator, transformers }:

cabal.mkDerivation (self: {
  pname = "blaze-builder-enumerator";
  version = "0.2.0.6";
  sha256 = "0pdw18drvikb465qh43b8wjyvpqj3wcilyczc21fri5ma4mxdkyp";
  buildDepends = [ blazeBuilder enumerator transformers ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/meiersi/blaze-builder-enumerator";
    description = "Enumeratees for the incremental conversion of builders to bytestrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
