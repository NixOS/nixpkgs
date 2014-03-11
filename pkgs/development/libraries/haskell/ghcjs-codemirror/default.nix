{ cabal }:

cabal.mkDerivation (self: {
  pname = "ghcjs-codemirror";
  version = "0.0.0.1";
  sha256 = "04x5h0i4fgyc2c5ihrnk0w3l1f3avvcl115zlnich93nillgbnfw";
  meta = {
    homepage = "https://github.com/ghcjs/CodeMirror";
    description = "Installs CodeMirror JavaScript files";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
