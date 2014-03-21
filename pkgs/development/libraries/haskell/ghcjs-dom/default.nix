{ cabal, glib, gtk3, mtl, transformers, webkitgtk3 }:

cabal.mkDerivation (self: {
  pname = "ghcjs-dom";
  version = "0.0.4";
  sha256 = "1a3dv2l3s3aifcpivmnv308k2a1kb7r4x0z9gi83wc4xr9a8f08w";
  buildDepends = [ glib gtk3 mtl transformers webkitgtk3 ];
  meta = {
    description = "DOM library that supports both GHCJS and WebKitGTK";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
