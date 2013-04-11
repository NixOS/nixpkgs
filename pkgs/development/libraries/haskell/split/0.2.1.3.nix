{ cabal, QuickCheck }:

cabal.mkDerivation (self: {
  pname = "split";
  version = "0.2.1.3";
  sha256 = "1s3aga7asxz495bx7i72a6fkdlz1zv20rrrqg1avj7b1sjn3gy9w";
  testDepends = [ QuickCheck ];
  meta = {
    description = "Combinator library for splitting lists";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
