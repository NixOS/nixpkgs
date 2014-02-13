{ cabal, primitive, text, vector }:

cabal.mkDerivation (self: {
  pname = "foldl";
  version = "1.0.2";
  sha256 = "11cqmw102m2bskaknl8qr7hwyn94hfv2ind5fgvjw4hwgllr8v84";
  buildDepends = [ primitive text vector ];
  meta = {
    description = "Composable, streaming, and efficient left folds";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
