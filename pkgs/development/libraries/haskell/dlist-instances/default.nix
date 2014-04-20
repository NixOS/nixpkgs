{ cabal, dlist, semigroups }:

cabal.mkDerivation (self: {
  pname = "dlist-instances";
  version = "0.1";
  sha256 = "0r1j7djywqd7c224wc9ixkplj3m2mbf9k3ra7n92ja2kfpksm615";
  buildDepends = [ dlist semigroups ];
  meta = {
    homepage = "https://github.com/gregwebs/dlist-instances";
    description = "Difference lists instances";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
