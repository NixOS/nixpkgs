{ cabal, deepseq }:

cabal.mkDerivation (self: {
  pname = "parallel";
  version = "3.2.0.0";
  sha256 = "1wqdy9p7xqq84ffgzdakvqydxq9668r9xq3wyay9wlgrk83wd1sq";
  buildDepends = [ deepseq ];
  meta = {
    description = "Parallel programming library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
