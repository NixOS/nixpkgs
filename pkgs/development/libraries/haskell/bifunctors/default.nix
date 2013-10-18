{ cabal, semigroupoids, semigroups, tagged }:

cabal.mkDerivation (self: {
  pname = "bifunctors";
  version = "4.1.0.1";
  sha256 = "1mf1v64g5pr2k1jpc7i4994ki2fp5vkxg4n5v84lfbl2r3kr92yg";
  buildDepends = [ semigroupoids semigroups tagged ];
  meta = {
    homepage = "http://github.com/ekmett/bifunctors/";
    description = "Bifunctors";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
