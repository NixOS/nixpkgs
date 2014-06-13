{ cabal, ghcjsBase, mtl }:

cabal.mkDerivation (self: {
  pname = "ghcjs-dom";
  version = "0.0.9";
  sha256 = "0vphhm9wr80p4brcjzhmp2kh0a5rlwzif26w2q054fshxa97kv2a";
  buildDepends = [ ghcjsBase mtl ];
  meta = {
    description = "DOM library that supports both GHCJS and WebKitGTK";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
