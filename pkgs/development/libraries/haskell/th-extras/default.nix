{ cabal, Cabal, syb }:

cabal.mkDerivation (self: {
  pname = "th-extras";
  version = "0.0.0.1";
  sha256 = "13d9fs48z87inma3kg9b7lfjp3h8j85fav6awd1zj3i2nl214hff";
  buildDepends = [ Cabal syb ];
  meta = {
    homepage = "https://github.com/mokus0/th-extras";
    description = "A grab bag of useful functions for use with Template Haskell";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
