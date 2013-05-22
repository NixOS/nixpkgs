{ cabal, hspec, setenv }:

cabal.mkDerivation (self: {
  pname = "base-compat";
  version = "0.2.1";
  sha256 = "1yssx3nww89dmkw8i55bp1vinbczbxhhh0kh4f3b9fyw5ylnai43";
  testDepends = [ hspec setenv ];
  meta = {
    description = "A compatibility layer for base";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
