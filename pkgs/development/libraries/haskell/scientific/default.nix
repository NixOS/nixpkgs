{ cabal, deepseq, hashable, smallcheck, tasty, tastySmallcheck
, text
}:

cabal.mkDerivation (self: {
  pname = "scientific";
  version = "0.1.0.1";
  sha256 = "0s401gxwap4xwz9rxypc76rs5w344s3an45295ybf3id6yal5140";
  buildDepends = [ deepseq hashable text ];
  testDepends = [ smallcheck tasty tastySmallcheck text ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/basvandijk/scientific";
    description = "Arbitrary-precision floating-point numbers represented using scientific notation";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
