{ cabal, aeson, binary, deepseq, filepath, Glob, hastache, mtl
, mwcRandom, parsec, statistics, text, time, transformers, vector
, vectorAlgorithms
}:

cabal.mkDerivation (self: {
  pname = "criterion";
  version = "0.8.1.0";
  sha256 = "0yzrnma2whd4dnjiy4w24syxgnz1b5bflsi20hrbgd5rmx85k2zd";
  buildDepends = [
    aeson binary deepseq filepath Glob hastache mtl mwcRandom parsec
    statistics text time transformers vector vectorAlgorithms
  ];
  meta = {
    homepage = "https://github.com/bos/criterion";
    description = "Robust, reliable performance measurement and analysis";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
