{ cabal, bitsAtomic, Cabal, primitive }:

cabal.mkDerivation (self: {
  pname = "atomic-primops";
  version = "0.2.2";
  sha256 = "1a3svsh96pl6915g70sf9zhqby0ahhifww6m13cn0zr4za32vl7n";
  buildDepends = [ bitsAtomic Cabal primitive ];
  meta = {
    homepage = "https://github.com/rrnewton/haskell-lockfree-queue/wiki";
    description = "A safe approach to CAS and other atomic ops in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
