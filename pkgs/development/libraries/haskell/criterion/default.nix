{ cabal, aeson, binary, deepseq, filepath, Glob, hastache, mtl
, mwcRandom, parsec, statistics, time, transformers, vector
, vectorAlgorithms
}:

cabal.mkDerivation (self: {
  pname = "criterion";
  version = "0.8.0.0";
  sha256 = "05v4glwvidsd4gm2jcvmlcpfaxg2x0fb69w051rbwg9scanrm7bf";
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
