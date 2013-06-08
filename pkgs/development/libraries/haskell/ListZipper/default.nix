{ cabal, QuickCheck }:

cabal.mkDerivation (self: {
  pname = "ListZipper";
  version = "1.2.0.2";
  sha256 = "0z3izxpl21fxz43jpx7zqs965anb3gp5vidv3pwwznr88ss2j6a9";
  buildDepends = [ QuickCheck ];
  meta = {
    description = "Simple zipper for lists";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
