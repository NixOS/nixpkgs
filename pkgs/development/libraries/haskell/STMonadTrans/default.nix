{ cabal, mtl }:

cabal.mkDerivation (self: {
  pname = "STMonadTrans";
  version = "0.3.2";
  sha256 = "1cl5bsc5mr3silcmbjylgw5qa04pf2np9mippxnsa4p3dk089gkh";
  buildDepends = [ mtl ];
  meta = {
    description = "A monad transformer version of the ST monad";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
