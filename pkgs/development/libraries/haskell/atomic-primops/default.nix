{ cabal, Cabal, primitive }:

cabal.mkDerivation (self: {
  pname = "atomic-primops";
  version = "0.5";
  sha256 = "0pni44gi9sh4l3hxwh7bqadhh6nc7v8w869sv9n45vkxwhhwbk4i";
  buildDepends = [ Cabal primitive ];
  meta = {
    homepage = "https://github.com/rrnewton/haskell-lockfree-queue/wiki";
    description = "A safe approach to CAS and other atomic ops in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
