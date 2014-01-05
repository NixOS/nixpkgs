{ cabal, errorcallEqInstance, hspec, setenv }:

cabal.mkDerivation (self: {
  pname = "base-compat";
  version = "0.3.0";
  sha256 = "0jjj953hr00jj99ld2977al6n6qk67ds9qfzkzwkh5ifgmi6f20i";
  buildDepends = [ errorcallEqInstance ];
  testDepends = [ hspec setenv ];
  meta = {
    description = "A compatibility layer for base";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
