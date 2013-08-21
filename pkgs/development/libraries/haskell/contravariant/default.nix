{ cabal, tagged, transformers, transformersCompat }:

cabal.mkDerivation (self: {
  pname = "contravariant";
  version = "0.4.4";
  sha256 = "1b4422wpcyvrf4r7rr8c8wa008f5ykaxs17vr4plp91rcczr87s4";
  buildDepends = [ tagged transformers transformersCompat ];
  meta = {
    homepage = "http://github.com/ekmett/contravariant/";
    description = "Contravariant functors";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
