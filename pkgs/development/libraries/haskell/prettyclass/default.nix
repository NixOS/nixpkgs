{ cabal }:

cabal.mkDerivation (self: {
  pname = "prettyclass";
  version = "1.0.0.0";
  sha256 = "11l9ajci7nh1r547hx8hgxrhq8mh5gdq30pdf845wvilg9p48dz5";
  meta = {
    description = "Pretty printing class similar to Show";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
