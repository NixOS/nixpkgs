{ cabal, binary, dataAccessor, deepseq, distributedStatic, hashable
, mtl, networkTransport, random, rank1dynamic, stm, syb, time
, transformers
}:

cabal.mkDerivation (self: {
  pname = "distributed-process";
  version = "0.5.0";
  sha256 = "16lfmkhc6jk2n46w39vf0q1ql426h5jrjgdi6cyjgwy1d5kaqcny";
  buildDepends = [
    binary dataAccessor deepseq distributedStatic hashable mtl
    networkTransport random rank1dynamic stm syb time transformers
  ];
  meta = {
    homepage = "http://haskell-distributed.github.com/";
    description = "Cloud Haskell: Erlang-style concurrency in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
