{ cabal, comonad, contravariant, semigroups, transformers }:

cabal.mkDerivation (self: {
  pname = "semigroupoids";
  version = "3.0.0.1";
  sha256 = "0ilqmpywiwp9m1k8lrw0mxb0pzc9l8bs2hgzrp8k5iln1yq1fh6i";
  buildDepends = [ comonad contravariant semigroups transformers ];
  meta = {
    homepage = "http://github.com/ekmett/semigroupoids";
    description = "Haskell 98 semigroupoids: Category sans id";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
