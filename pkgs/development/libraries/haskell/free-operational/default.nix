{ cabal, comonadTransformers, free, kanExtensions, mtl, comonad
, transformers
}:

cabal.mkDerivation (self: {
  pname = "free-operational";
  version = "0.5.0.0";
  sha256 = "0gim4m0l76sxxg6a8av1gl6qjpwxwdzyviij86d06v1150r08dmb";
  jailbreak = true;             # needs an old version of kan-extensions
  buildDepends = [
    comonadTransformers free kanExtensions mtl transformers comonad
  ];
  meta = {
    description = "Operational Applicative, Alternative, Monad and MonadPlus from free types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
