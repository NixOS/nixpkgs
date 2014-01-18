{ cabal, aeson, doctest, lens, text, unorderedContainers, vector }:

cabal.mkDerivation (self: {
  pname = "aeson-lens";
  version = "0.5.0.0";
  sha256 = "1pr8cxkx41wi7095cp1gpqrwadwx6azcrdi1kr1ik0fs6606dkks";
  buildDepends = [ aeson lens text unorderedContainers vector ];
  testDepends = [ doctest ];
  meta = {
    description = "Lens of Aeson";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
