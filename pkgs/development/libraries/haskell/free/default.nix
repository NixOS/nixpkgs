{ cabal, bifunctors, comonad, distributive, mtl, preludeExtras
, profunctors, semigroupoids, semigroups, transformers
}:

cabal.mkDerivation (self: {
  pname = "free";
  version = "4.7.1";
  sha256 = "14qvc153g7n8fkl2giyyya8l7fs4limgnm18hdw5dpj841kwxgzm";
  buildDepends = [
    bifunctors comonad distributive mtl preludeExtras profunctors
    semigroupoids semigroups transformers
  ];
  jailbreak = true;
  meta = {
    homepage = "http://github.com/ekmett/free/";
    description = "Monads for free";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
