{ cabal, either, safe, transformers }:

cabal.mkDerivation (self: {
  pname = "errors";
  version = "1.4.2";
  sha256 = "1csry8bbz7r4gc7x3lf1ih10rvnig2i91nfij227p9744yndl2xw";
  buildDepends = [ either safe transformers ];
  jailbreak = true;
  meta = {
    description = "Simplified error-handling";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
