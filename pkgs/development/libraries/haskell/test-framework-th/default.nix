{ cabal, haskellSrcExts, languageHaskellExtract, regexPosix
, testFramework
}:

cabal.mkDerivation (self: {
  pname = "test-framework-th";
  version = "0.2.3";
  sha256 = "1xls8034zkfnvkv2p6jd6kc1x3xrr0sm5c6hl0mp7ym2w2ww9f1w";
  buildDepends = [
    haskellSrcExts languageHaskellExtract regexPosix testFramework
  ];
  meta = {
    homepage = "http://github.com/finnsson/test-generator";
    description = "Automagically generate the HUnit- and Quickcheck-bulk-code using Template Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
