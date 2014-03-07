{ cabal, Cabal, deepseq, QuickCheck, testFramework
, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "time";
  version = "1.4.2";
  sha256 = "1kpsak2wka23c8591ry6i1d7hmd54s7iw5n6hpx48jhcxf1w199h";
  buildDepends = [ deepseq ];
  testDepends = [
    Cabal deepseq QuickCheck testFramework testFrameworkQuickcheck2
  ];
  meta = {
    homepage = "http://semantic.org/TimeLib/";
    description = "A time library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
