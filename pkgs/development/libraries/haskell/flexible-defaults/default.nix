{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "flexible-defaults";
  version = "0.0.0.2";
  sha256 = "0hr3x4hlah6pd88xvr9lgvz1v4pyxpyv6q9zms96jkm5wc4mkbwx";
  buildDepends = [ transformers ];
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
