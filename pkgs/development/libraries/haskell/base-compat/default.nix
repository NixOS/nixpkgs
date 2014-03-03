{ cabal, errorcallEqInstance, hspec, setenv }:

cabal.mkDerivation (self: {
  pname = "base-compat";
  version = "0.4.0";
  sha256 = "0ps26w4mjp465a3mh3hpzkdkc97yvfhzh86fcnlqszy9wgj13w65";
  buildDepends = [ errorcallEqInstance ];
  testDepends = [ hspec setenv ];
  meta = {
    description = "A compatibility layer for base";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
