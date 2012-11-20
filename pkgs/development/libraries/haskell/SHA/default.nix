{ cabal, binary, QuickCheck, testFramework
, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "SHA";
  version = "1.6.0";
  sha256 = "0i5x2irk08yr4p428wyqvdysz22jqc3q5qn08wc38pw2xhmc0zzk";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary QuickCheck testFramework testFrameworkQuickcheck2
  ];
  meta = {
    description = "Implementations of the SHA suite of message digest functions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
