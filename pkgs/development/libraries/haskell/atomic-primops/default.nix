{ cabal, bitsAtomic, Cabal, primitive }:

cabal.mkDerivation (self: {
  pname = "atomic-primops";
  version = "0.4";
  sha256 = "01sg0yn25fs0z7dmrvhyp3amay9l028xs570xhy6vvplrji1mxf0";
  buildDepends = [ bitsAtomic Cabal primitive ];
  meta = {
    homepage = "https://github.com/rrnewton/haskell-lockfree-queue/wiki";
    description = "A safe approach to CAS and other atomic ops in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
