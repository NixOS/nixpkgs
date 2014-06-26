{ cabal, primitive, text, transformers, vector }:

cabal.mkDerivation (self: {
  pname = "foldl";
  version = "1.0.5";
  sha256 = "08yjzzplg715hzkhwbf8nv2zm7c5wd2kph4zx94iml0cnc6ip048";
  buildDepends = [ primitive text transformers vector ];
  meta = {
    description = "Composable, streaming, and efficient left folds";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
