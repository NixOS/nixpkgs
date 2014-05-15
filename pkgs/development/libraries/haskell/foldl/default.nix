{ cabal, primitive, text, transformers, vector }:

cabal.mkDerivation (self: {
  pname = "foldl";
  version = "1.0.4";
  sha256 = "0l5gyaw2rb0wfdm5q13vsxfr0z2y9ad5nsjh605p1jp8i0rgwgkv";
  buildDepends = [ primitive text transformers vector ];
  meta = {
    description = "Composable, streaming, and efficient left folds";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
