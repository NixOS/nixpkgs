{ cabal, syb }:

cabal.mkDerivation (self: {
  pname = "syz";
  version = "0.2.0.0";
  sha256 = "1m5395937yyxsa1bmlfn1dxa1jr15yjhlz9s15bpwapshcd8119y";
  buildDepends = [ syb ];
  meta = {
    homepage = "http://www.cs.indiana.edu/~adamsmd/papers/scrap_your_zippers/";
    description = "Scrap Your Zippers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
