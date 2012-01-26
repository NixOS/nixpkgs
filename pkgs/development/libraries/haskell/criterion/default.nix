{ cabal, aeson, deepseq, hastache, mtl, mwcRandom, parsec
, statistics, time, transformers, vector, vectorAlgorithms
}:

cabal.mkDerivation (self: {
  pname = "criterion";
  version = "0.6.0.1";
  sha256 = "0k6ip41w5h1z8gl67a8vsb6c3md5nc4yh1vd6dysp9fqgn0vky0a";
  buildDepends = [
    aeson deepseq hastache mtl mwcRandom parsec statistics time
    transformers vector vectorAlgorithms
  ];
  meta = {
    homepage = "https://github.com/bos/criterion";
    description = "Robust, reliable performance measurement and analysis";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
