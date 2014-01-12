{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "foldl";
  version = "1.0.1";
  sha256 = "194dkpjh0964cmh4mg35qffkg8dx8d821aj8k6khb40fq5s8smjy";
  buildDepends = [ text ];
  meta = {
    description = "Composable, streaming, and efficient left folds";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
