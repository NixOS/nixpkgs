{ cabal, mmorph, transformers }:

cabal.mkDerivation (self: {
  pname = "pipes";
  version = "3.3.0";
  sha256 = "1bgznfv7hxqwj5f7vkm8d41phw63bl2swzr0wrz0pcqxlr42likb";
  buildDepends = [ mmorph transformers ];
  meta = {
    description = "Compositional pipelines";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
