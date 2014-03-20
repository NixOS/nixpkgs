{ cabal, ghcjsBase, mtl }:

cabal.mkDerivation (self: {
  pname = "ghcjs-dom";
  version = "0.0.6";
  sha256 = "0c27mf5cjvw5q4lwbmi245q4y09b61y5s6hxsfzgdn4lhfbvdma6";
  buildDepends = [ ghcjsBase mtl ];
  meta = {
    description = "DOM library that supports both GHCJS and WebKitGTK";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
