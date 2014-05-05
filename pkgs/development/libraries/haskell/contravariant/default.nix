{ cabal, tagged, transformers, transformersCompat }:

cabal.mkDerivation (self: {
  pname = "contravariant";
  version = "0.5.2";
  sha256 = "05lnipshhjh8ld0c24h675rgljr54203vv9a4fsivw4asaj24q7y";
  buildDepends = [ tagged transformers transformersCompat ];
  meta = {
    homepage = "http://github.com/ekmett/contravariant/";
    description = "Contravariant functors";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
