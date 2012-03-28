{ cabal, blazeBuilder, enumerator, transformers }:

cabal.mkDerivation (self: {
  pname = "blaze-builder-enumerator";
  version = "0.2.0.3";
  sha256 = "00a9rly27sh49gi5askg7z3ji8ig9llxk4qcznsag01d1z0kb97n";
  buildDepends = [ blazeBuilder enumerator transformers ];
  meta = {
    homepage = "https://github.com/meiersi/blaze-builder-enumerator";
    description = "Enumeratees for the incremental conversion of builders to bytestrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
