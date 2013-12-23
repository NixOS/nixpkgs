{ cabal, nonNegative, QuickCheck, transformers, utilityHt }:

cabal.mkDerivation (self: {
  pname = "event-list";
  version = "0.1.0.2";
  sha256 = "01j48871nijhkbqdsfvbvq01yr9b5a056fn03ccgazikfsd368ri";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ nonNegative QuickCheck transformers utilityHt ];
  meta = {
    homepage = "http://code.haskell.org/~thielema/event-list/";
    description = "Event lists with relative or absolute time stamps";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
  };
})
