{ cabal, comonad, tagged }:

cabal.mkDerivation (self: {
  pname = "profunctors";
  version = "3.2";
  sha256 = "0c7242pk5hfz67cwjy0l7skqyz20akw9j2w7cb8iggcbbb27bgyc";
  buildDepends = [ comonad tagged ];
  meta = {
    homepage = "http://github.com/ekmett/profunctors/";
    description = "Haskell 98 Profunctors";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
