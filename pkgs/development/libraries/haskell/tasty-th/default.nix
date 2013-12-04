{ cabal, languageHaskellExtract, tasty }:

cabal.mkDerivation (self: {
  pname = "tasty-th";
  version = "0.1.1";
  sha256 = "0ndwfz2gq0did6dfjilhdaxzya2qw9gckjkj090cp2rbkahywsga";
  buildDepends = [ languageHaskellExtract tasty ];
  meta = {
    homepage = "http://github.com/bennofs/tasty-th";
    description = "Automagically generate the HUnit- and Quickcheck-bulk-code using Template Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
