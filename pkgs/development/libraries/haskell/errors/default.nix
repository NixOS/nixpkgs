{ cabal, either, safe, transformers }:

cabal.mkDerivation (self: {
  pname = "errors";
  version = "1.4.5";
  sha256 = "16m4psk1150319bd2hrswpp2h90l1hhh7w13arfhy4ylh8vscm4q";
  buildDepends = [ either safe transformers ];
  jailbreak = true;
  meta = {
    description = "Simplified error-handling";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
