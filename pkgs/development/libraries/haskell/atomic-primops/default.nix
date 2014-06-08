{ cabal, primitive }:

cabal.mkDerivation (self: {
  pname = "atomic-primops";
  version = "0.6.0.5";
  sha256 = "0xyvadhmhk2b6y6p52cfbjx1hs3zfcwfa5wx6cypaq4yi3csyl5k";
  buildDepends = [ primitive ];
  meta = {
    homepage = "https://github.com/rrnewton/haskell-lockfree/wiki";
    description = "A safe approach to CAS and other atomic ops in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
