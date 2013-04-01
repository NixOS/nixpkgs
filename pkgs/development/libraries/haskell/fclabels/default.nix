{ cabal, mtl, transformers }:

cabal.mkDerivation (self: {
  pname = "fclabels";
  version = "1.1.5";
  sha256 = "0g9h1mayzf8v9dg84b54cqjbz9m9hdmj9a2zh0lg2kbc1v7iwlx1";
  buildDepends = [ mtl transformers ];
  meta = {
    description = "First class accessor labels";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
