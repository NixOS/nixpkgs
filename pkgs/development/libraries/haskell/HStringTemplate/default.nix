{ cabal, deepseq, filepath, mtl, parsec, syb, sybWithClass, text
, time, utf8String
}:

cabal.mkDerivation (self: {
  pname = "HStringTemplate";
  version = "0.6.9";
  sha256 = "0xa665q5gya51vjkg1i6f6qk67jx28xcbxs5v1d9yr1f8djh5d9v";
  buildDepends = [
    deepseq filepath mtl parsec syb sybWithClass text time utf8String
  ];
  meta = {
    description = "StringTemplate implementation in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
