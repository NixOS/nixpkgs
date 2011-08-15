{ cabal }:

cabal.mkDerivation (self: {
  pname = "semigroups";
  version = "0.7.1.2";
  sha256 = "13kn5c7dmaaswp85kiyywgdl84rdcz32i8p7q5p3ahnazrp8iw5r";
  meta = {
    homepage = "http://github.com/ekmett/semigroups/";
    description = "Haskell 98 semigroups";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
