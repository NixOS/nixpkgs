{ cabal, deepseq }:

cabal.mkDerivation (self: {
  pname = "parallel";
  version = "3.2.0.4";
  sha256 = "0v8l2rbczjadynbz4q4r00k8a1mqj70y63zbklpxckafq1zn7nwc";
  buildDepends = [ deepseq ];
  meta = {
    description = "Parallel programming library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
