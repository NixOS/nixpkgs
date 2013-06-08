{ cabal, numtypeTf, time }:

cabal.mkDerivation (self: {
  pname = "dimensional-tf";
  version = "0.1.1";
  sha256 = "0hhp2nx8xyk5ms3mzg1d3jhzm1b0bxz7aijxqasrxjq9p04jr2ci";
  buildDepends = [ numtypeTf time ];
  meta = {
    homepage = "http://dimensional.googlecode.com/";
    description = "Statically checked physical dimensions, implemented using type families";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
