{ cabal, haskellSrcExts, languageHaskellExtract, regexPosix
, testFramework
}:

cabal.mkDerivation (self: {
  pname = "test-framework-th";
  version = "0.2.4";
  sha256 = "12lw7yj02jb9s0i7rb98jjam43j2h0gzmnbj9zi933fx7sg0sy4b";
  buildDepends = [
    haskellSrcExts languageHaskellExtract regexPosix testFramework
  ];
  meta = {
    homepage = "http://github.com/finnsson/test-generator";
    description = "Automagically generate the HUnit- and Quickcheck-bulk-code using Template Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
