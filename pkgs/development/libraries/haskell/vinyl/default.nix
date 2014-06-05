{ cabal, doctest, lens, singletons }:

cabal.mkDerivation (self: {
  pname = "vinyl";
  version = "0.4";
  sha256 = "16v13bd5dvm9axngx1pvm7bq9412f6awz0cggsif1z0dy2kjpwgb";
  testDepends = [ doctest lens singletons ];
  meta = {
    description = "Extensible Records";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
