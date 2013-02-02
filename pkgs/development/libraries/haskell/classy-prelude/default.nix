{ cabal, basicPrelude, hashable, liftedBase, systemFilepath, text
, transformers, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "classy-prelude";
  version = "0.4.4";
  sha256 = "0f49b07r5isz57wjmgpfvq4hg9m5q59ad918rk1v24xdvn4y3all";
  buildDepends = [
    basicPrelude hashable liftedBase systemFilepath text transformers
    unorderedContainers vector
  ];
  meta = {
    homepage = "https://github.com/snoyberg/classy-prelude";
    description = "A typeclass-based Prelude";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
