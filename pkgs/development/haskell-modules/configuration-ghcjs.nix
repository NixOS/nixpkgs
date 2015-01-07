{ pkgs }:

with import ./lib.nix;

self: super: {

  # This is the list of packages that are built into a booted ghcjs installation
  # It can be generated with the command:
  # nix-shell '<nixpkgs>' -A pkgs.haskellPackages_ghcjs.ghc --command "ghcjs-pkg list | sed -n 's/^    \(.*\)-\([0-9.]*\)$/\1_\2/ p' | sed 's/\./_/g' | sed 's/-\(.\)/\U\1/' | sed 's/^\([^_]*\)\(.*\)$/\1 = null;/'"
  Cabal = null;
  aeson = null;
  array = null;
  async = null;
  attoparsec = null;
  base = null;
  binary = null;
  rts = null;
  bytestring = null;
  caseInsensitive = null;
  containers = null;
  deepseq = null;
  directory = null;
  dlist = null;
  extensibleExceptions = null;
  filepath = null;
  ghcPrim = null;
  ghcjsBase = null;
  ghcjsPrim = null;
  hashable = null;
  integerGmp = null;
  mtl = null;
  oldLocale = null;
  oldTime = null;
  parallel = null;
  pretty = null;
  primitive = null;
  process = null;
  scientific = null;
  stm = null;
  syb = null;
  templateHaskell = null;
  text = null;
  time = null;
  transformers = null;
  unix = null;
  unorderedContainers = null;
  vector = null;

}
