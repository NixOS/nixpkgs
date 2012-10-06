{ cabal, binary, dataAccessor, distributedStatic, mtl
, networkTransport, random, rank1dynamic, stm, syb, time
, transformers
}:

cabal.mkDerivation (self: {
  pname = "distributed-process";
  version = "0.3.1";
  sha256 = "048j27mpdmknz2s4ja3q2mla1d2sjbvrpmzx0lz2qas123qz1siq";
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
