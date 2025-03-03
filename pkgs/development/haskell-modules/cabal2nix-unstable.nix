# This file defines cabal2nix-unstable, used by maintainers/scripts/haskell/regenerate-hackage-packages.sh.
{
  mkDerivation,
  aeson,
  ansi-wl-pprint,
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
  version = "unstable-2025-03-03";
  src = fetchzip {
    url = "https://github.com/NixOS/cabal2nix/archive/001aa9757c178c7d3069bc828cfea41b550c26ef.tar.gz";
    sha256 = "1f5kxhbr78h4d0i4lhfkqijc783jlrpfrv7gq2x37c94p213agg4";
  };
  postUnpack = "sourceRoot+=/cabal2nix; echo source root reset to $sourceRoot";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson
    ansi-wl-pprint
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
