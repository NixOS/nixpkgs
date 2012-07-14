{ cabal, extensibleExceptions, random }:

cabal.mkDerivation (self: {
  pname = "QuickCheck";
  version = "2.5";
  sha256 = "0a4ibyw5abm7ds6pds41147phjkccx8v60vqdj05c5n28hbzbgbh";
  buildDepends = [ extensibleExceptions random ];
  meta = {
    homepage = "http://code.haskell.org/QuickCheck";
    description = "Automatic testing of Haskell programs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
