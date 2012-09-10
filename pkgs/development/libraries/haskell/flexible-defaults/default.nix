{ cabal, thExtras, transformers }:

cabal.mkDerivation (self: {
  pname = "flexible-defaults";
  version = "0.0.1.0";
  sha256 = "0vq8ci3zbzmw8abjd12dhjiqzz4ckr99c1fqk32qsp5bvm81bdma";
  buildDepends = [ thExtras transformers ];
  meta = {
    homepage = "https://github.com/mokus0/flexible-defaults";
    description = "Generate default function implementations for complex type classes";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
