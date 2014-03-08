{ cabal, aeson, binary, deepseq, filepath, Glob, hastache, mtl
, mwcRandom, parsec, statistics, time, transformers, vector
, vectorAlgorithms
}:

cabal.mkDerivation (self: {
  pname = "criterion";
  version = "0.8.0.1";
  sha256 = "1f4wsaiyq0zks71jgfx43774vxkf9l362a9kfd2jhsnxx7zkv5sq";
  buildDepends = [
    aeson binary deepseq filepath Glob hastache mtl mwcRandom parsec
    statistics time transformers vector vectorAlgorithms
  ];
  meta = {
    homepage = "https://github.com/bos/criterion";
    description = "Robust, reliable performance measurement and analysis";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
