{ cabal, ghcjsBase, mtl }:

cabal.mkDerivation (self: {
  pname = "ghcjs-dom";
  version = "0.0.10";
  sha256 = "0xffr197m6qam4q7ckgcwl0v9kwrxa5fm894c9vyxdmlcjyn38rm";
  buildDepends = [ ghcjsBase mtl ];
  meta = {
    description = "DOM library that supports both GHCJS and WebKitGTK";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
