{ cabal }:

cabal.mkDerivation (self: {
  pname = "setlocale";
  version = "0.0.3";
  sha256 = "08pd20ibmslr94p52rn6x9w3swn9jy7vjlvxzw29h8dlqgmvcrjl";
  meta = {
    description = "A Haskell interface to setlocale()";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
  };
})
