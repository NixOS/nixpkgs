{ cabal, extensibleExceptions, random }:

cabal.mkDerivation (self: {
  pname = "QuickCheck";
  version = "2.4.2";
  sha256 = "17qp73sdp780lha3i6xdsrvgshqz47qwldqknadc0w3vmscw61bg";
  buildDepends = [ extensibleExceptions random ];
  meta = {
    homepage = "http://code.haskell.org/QuickCheck";
    description = "Automatic testing of Haskell programs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
