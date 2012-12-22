{ cabal, binary, dataAccessor, distributedStatic, mtl
, networkTransport, random, rank1dynamic, stm, syb, time
, transformers
}:

cabal.mkDerivation (self: {
  pname = "distributed-process";
  version = "0.4.1";
  sha256 = "1ysm2rq7ldxb5w6m04vf5q3zrgvg99z7kszjqj17r17ps61v898f";
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
