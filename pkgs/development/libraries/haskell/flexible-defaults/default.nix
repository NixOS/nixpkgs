{ cabal, thExtras, transformers }:

cabal.mkDerivation (self: {
  pname = "flexible-defaults";
  version = "0.0.1.1";
  sha256 = "0cbp8hb7y29xz3hl780173cs6ca4df0r98fz7v3drqr46aq55ipl";
  buildDepends = [ thExtras transformers ];
  meta = {
    homepage = "https://github.com/mokus0/flexible-defaults";
    description = "Generate default function implementations for complex type classes";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
