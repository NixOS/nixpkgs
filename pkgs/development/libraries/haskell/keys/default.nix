{ cabal, comonadsFd, comonadTransformers, free, semigroupoids
, semigroups, transformers
}:

cabal.mkDerivation (self: {
  pname = "keys";
  version = "3.0.3";
  sha256 = "1fqw0745pj8pzjjlrbg85gdr3acm7gpip5052m9wcz997949ca3r";
  buildDepends = [
    comonadsFd comonadTransformers free semigroupoids semigroups
    transformers
  ];
  meta = {
    homepage = "http://github.com/ekmett/keys/";
    description = "Keyed functors and containers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
