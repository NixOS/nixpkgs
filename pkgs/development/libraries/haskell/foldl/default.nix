{ cabal }:

cabal.mkDerivation (self: {
  pname = "foldl";
  version = "1.0.0";
  sha256 = "0r9lkyw33231nfl9ly25hk2i7k3c8ssmng473xvk76zkcrksj131";
  meta = {
    description = "Composable, streaming, and efficient left folds";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
