{ cabal, deepseq, nonNegative, parsec, QuickCheck, random
, storableRecord, utilityHt
}:

cabal.mkDerivation (self: {
  pname = "numeric-prelude";
  version = "0.4.0.1";
  sha256 = "1j361gj7cw31x31vnjhxmy7a62ldvyyqfm7irhff7sf5gv4kr5wh";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    deepseq nonNegative parsec QuickCheck random storableRecord
    utilityHt
  ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Numeric_Prelude";
    description = "An experimental alternative hierarchy of numeric type classes";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
