{ cabal, ghcjsBase, mtl }:

cabal.mkDerivation (self: {
  pname = "ghcjs-dom";
  version = "0.0.7";
  sha256 = "1yg2c0slndg3y9bk95xkbgl8zp4lmcgw9wk3jkk1sdizn3y3yggq";
  buildDepends = [ ghcjsBase mtl ];
  meta = {
    description = "DOM library that supports both GHCJS and WebKitGTK";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
