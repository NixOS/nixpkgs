{ cabal, tagged, transformers, transformersCompat }:

cabal.mkDerivation (self: {
  pname = "contravariant";
  version = "0.4.1";
  sha256 = "0alzl47lqzw9fqjqxdfy40f1aynd8mc00b2h7fj2ch0zq82hm85q";
  buildDepends = [ tagged transformers transformersCompat ];
  meta = {
    homepage = "http://github.com/ekmett/contravariant/";
    description = "Contravariant functors";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
