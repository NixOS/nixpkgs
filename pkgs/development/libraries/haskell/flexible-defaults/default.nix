{ cabal, thExtras, transformers }:

cabal.mkDerivation (self: {
  pname = "flexible-defaults";
  version = "0.0.0.3";
  sha256 = "1s0dz61bqzzbxqvn9i8zwaccsha15als45zzjs2yc11r3m151dla";
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
