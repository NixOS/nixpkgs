{ cabal, deepseq }:

cabal.mkDerivation (self: {
  pname = "time";
  version = "1.4.0.1";
  sha256 = "046jyz2xnbg2s94d9xhpphgq93mqlky7bc50vss40wdk6l7w8aws";
  buildDepends = [ deepseq ];
  meta = {
    homepage = "http://semantic.org/TimeLib/";
    description = "A time library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
