{ cabal, HUnit, deepseq }:

cabal.mkDerivation (self: {
  pname = "monad-par";
  version = "0.1.0.1";
  sha256 = "0sd5w09vi12jwzz8xgh51r27577byr6pqp15dw0z5nhf4w869qxq";
  buildDepends = [ HUnit deepseq ];
  meta = {
    homepage = "https://github.com/simonmar/monad-par";
    description = "A library for parallel programming based on a monad";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
