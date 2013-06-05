{ cabal, dataDefaultClass, dlist }:

cabal.mkDerivation (self: {
  pname = "data-default-instances-dlist";
  version = "0.0.1";
  sha256 = "0narkdqiprhgayjiawrr4390h4rq4pl2pb6mvixbv2phrc8kfs3x";
  buildDepends = [ dataDefaultClass dlist ];
  meta = {
    description = "Default instances for types in dlist";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
