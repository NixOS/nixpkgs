{ cabal, binary }:

cabal.mkDerivation (self: {
  pname = "SHA";
  version = "1.4.1.3";
  sha256 = "1sx68mvzb2y3dq9hk769fzp8vw4jf4hk5v45i0a9a8b31imlicf0";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ binary ];
  meta = {
    description = "Implementations of the SHA suite of message digest functions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
