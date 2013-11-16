{ cabal, semigroupoids, semigroups, tagged }:

cabal.mkDerivation (self: {
  pname = "bifunctors";
  version = "4.1.1";
  sha256 = "0apdnhfqn3xyi99d5ybc51y2i0gpxix5hlaqxgpbzr4b0zkk7c4w";
  buildDepends = [ semigroupoids semigroups tagged ];
  meta = {
    homepage = "http://github.com/ekmett/bifunctors/";
    description = "Bifunctors";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
