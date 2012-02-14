{ cabal, Cabal, text }:

cabal.mkDerivation (self: {
  pname = "path-pieces";
  version = "0.1.0";
  sha256 = "12dgiq2pz94pwa5v5wv96ps0nl5w23r44nnp4lm4cdhl063c9w8d";
  buildDepends = [ Cabal text ];
  meta = {
    homepage = "http://github.com/snoyberg/path-pieces";
    description = "Components of paths";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
