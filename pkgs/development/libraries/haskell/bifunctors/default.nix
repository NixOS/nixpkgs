{ cabal, semigroupoids, semigroups, tagged }:

cabal.mkDerivation (self: {
  pname = "bifunctors";
  version = "3.2.0.1";
  sha256 = "1biicx0zi48wzzi7vkhzvrdyk59hmmm1bqbsga6x5nbrbf3qrkm6";
  buildDepends = [ semigroupoids semigroups tagged ];
  meta = {
    homepage = "http://github.com/ekmett/bifunctors/";
    description = "Haskell 98 bifunctors";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
