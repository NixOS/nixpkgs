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
<<<<<<< HEAD
  version = "2.20.1-unstable-2025-11-20";
  src = fetchzip {
    url = "https://github.com/NixOS/cabal2nix/archive/459859839cfe4fb352a29c1a72a1c4f0f537a1b8.tar.gz";
    sha256 = "1443hlbz29y2dn22kf91zx7g284zp3l2vgw6jg4wgx66v2sxrqii";
=======
  version = "2.20.1-unstable-2025-11-11";
  src = fetchzip {
    url = "https://github.com/NixOS/cabal2nix/archive/a152152295a9fa6698583e84a2b8c7eee1446296.tar.gz";
    sha256 = "1jpgzyc360g5snvc5ji6wqfvbsc7siwxvhrwafzzfg762niq0c49";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
