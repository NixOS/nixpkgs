{ cabal }:

cabal.mkDerivation (self: {
  pname = "deepseq";
  version = "1.1.0.0";
  sha256 = "947c45e7ee862159f190fb8e905c1328f7672cb9e6bf3abd1d207bbcf1eee50a";
  meta = {
    description = "Fully evaluate data structures";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
