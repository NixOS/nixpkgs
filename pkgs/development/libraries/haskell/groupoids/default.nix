{ cabal, semigroupoids }:

cabal.mkDerivation (self: {
  pname = "groupoids";
  version = "4.0";
  sha256 = "08la44c19pz2clws5mb939zc1d17cb6qy9qlh2n1634pl0zrawb6";
  buildDepends = [ semigroupoids ];
  meta = {
    homepage = "http://github.com/ekmett/groupoids/";
    description = "This package has been absorbed into semigroupoids 4.0";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
