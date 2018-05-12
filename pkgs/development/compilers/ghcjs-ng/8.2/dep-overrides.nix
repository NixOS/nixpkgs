{ haskellLib }:

let inherit (haskellLib) dontHaddock;
in self: super: {
  ghcjs = dontHaddock super.ghcjs;
}
