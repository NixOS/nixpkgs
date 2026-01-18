# This file defines cabal2nix-unstable, used by maintainers/scripts/haskell/regenerate-hackage-packages.sh.
{
  mkDerivation,
  aeson,
  ansi-terminal,
  base,
  bytestring,
  Cabal,
  containers,
  deepseq,
  directory,
  distribution-nixpkgs,
  fetchzip,
  filepath,
  hackage-db,
  hopenssl,
  hpack,
  language-nix,
  lens,
  lib,
  monad-par,
  monad-par-extras,
  mtl,
  optparse-applicative,
  pretty,
  prettyprinter,
  process,
  split,
  tasty,
  tasty-golden,
  text,
  time,
  transformers,
  yaml,
}:
mkDerivation {
  pname = "cabal2nix";
  version = "2.20.1-unstable-2025-11-20";
  src = fetchzip {
    url = "https://github.com/NixOS/cabal2nix/archive/459859839cfe4fb352a29c1a72a1c4f0f537a1b8.tar.gz";
    sha256 = "1443hlbz29y2dn22kf91zx7g284zp3l2vgw6jg4wgx66v2sxrqii";
  };
  postUnpack = "sourceRoot+=/cabal2nix; echo source root reset to $sourceRoot";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson
    ansi-terminal
    base
    bytestring
    Cabal
    containers
    deepseq
    directory
    distribution-nixpkgs
    filepath
    hackage-db
    hopenssl
    hpack
    language-nix
    lens
    optparse-applicative
    pretty
    prettyprinter
    process
    split
    text
    time
    transformers
    yaml
  ];
  executableHaskellDepends = [
    aeson
    base
    bytestring
    Cabal
    containers
    directory
    distribution-nixpkgs
    filepath
    hopenssl
    language-nix
    lens
    monad-par
    monad-par-extras
    mtl
    optparse-applicative
    pretty
  ];
  testHaskellDepends = [
    base
    Cabal
    containers
    directory
    filepath
    language-nix
    lens
    pretty
    process
    tasty
    tasty-golden
  ];
  preCheck = ''
    export PATH="$PWD/dist/build/cabal2nix:$PATH"
    export HOME="$TMPDIR/home"
  '';
  homepage = "https://github.com/nixos/cabal2nix#readme";
  description = "Convert Cabal files into Nix build instructions";
  license = lib.licenses.bsd3;
}
