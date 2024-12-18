{ pkgs, haskellLib }:

with haskellLib;

# cabal2nix doesn't properly add dependencies conditional on arch(javascript)
(self: super: {
  ghcjs-base = addBuildDepends (with self; [
    aeson
    attoparsec
    dlist
    hashable
    primitive
    scientific
    unordered-containers
    vector
  ]) super.ghcjs-base;

  ghcjs-dom = addBuildDepend self.ghcjs-dom-javascript super.ghcjs-dom;
  ghcjs-dom-javascript = addBuildDepend self.ghcjs-base super.ghcjs-dom-javascript;
  jsaddle = addBuildDepend self.ghcjs-base super.jsaddle;
  jsaddle-dom = addBuildDepend self.ghcjs-base super.jsaddle-dom;
})
