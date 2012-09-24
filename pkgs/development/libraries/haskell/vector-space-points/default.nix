{ cabal, newtype, vectorSpace }:

cabal.mkDerivation (self: {
  pname = "vector-space-points";
  version = "0.1.2.0";
  sha256 = "19azl6g14rsxs0qbik6x637qw9jv4xl01w65xd0xh7833mypmj6d";
  buildDepends = [ newtype vectorSpace ];
  meta = {
    description = "A type for points, as distinct from vectors";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
