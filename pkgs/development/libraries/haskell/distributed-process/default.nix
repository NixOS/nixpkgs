{ cabal, binary, dataAccessor, distributedStatic, mtl
, networkTransport, random, rank1dynamic, stm, syb, time
, transformers
}:

cabal.mkDerivation (self: {
  pname = "distributed-process";
  version = "0.4.2";
  sha256 = "16w8jp66903vn089ysqdn534v0744cr2m6wkqd77zri6a0caaa6c";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary dataAccessor distributedStatic mtl networkTransport random
    rank1dynamic stm syb time transformers
  ];
  noHaddock = true;
  meta = {
    homepage = "http://github.com/haskell-distributed/distributed-process";
    description = "Cloud Haskell: Erlang-style concurrency in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
