{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "flexible-defaults";
  version = "0.0.0.1";
  sha256 = "07a0gfs9qw1z5j1hq1m4aywgfmg67mkw6pc5xljyip99gvrxdngl";
  buildDepends = [ transformers ];
  meta = {
    homepage = "https://github.com/mokus0/flexible-defaults";
    description = "Generate default function implementations for complex type classes.";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
