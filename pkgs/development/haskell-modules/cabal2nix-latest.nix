# This file defines cabal2nix-latest, used by maintainers/scripts/regenerate-hackage-packages.sh.
{ mkDerivation, aeson, ansi-wl-pprint, base, bytestring, Cabal
, containers, deepseq, directory, distribution-nixpkgs, fetchzip
, filepath, hackage-db, hopenssl, hpack, language-nix, lens
, monad-par, monad-par-extras, mtl, optparse-applicative, pretty
, process, split, stdenv, tasty, tasty-golden, text, time
, transformers, yaml
}:
mkDerivation {
  pname = "cabal2nix";
  version = "2020-05-05";
  src = fetchzip {
    url = "https://github.com/NixOS/cabal2nix/archive/b7c82dbe6d2bb571c92771385bdee6451b087b0f.tar.gz";
    sha256 = "0gxzb368w8w7kg9y0imzr0bzr8qnvhblm9sz326p8yff26xbk9h5";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson ansi-wl-pprint base bytestring Cabal containers deepseq
    directory distribution-nixpkgs filepath hackage-db hopenssl hpack
    language-nix lens optparse-applicative pretty process split text
    time transformers yaml
  ];
  executableHaskellDepends = [
    aeson base bytestring Cabal containers directory
    distribution-nixpkgs filepath hopenssl language-nix lens monad-par
    monad-par-extras mtl optparse-applicative pretty
  ];
  testHaskellDepends = [
    base Cabal containers directory filepath language-nix lens pretty
    process tasty tasty-golden
  ];
  preCheck = ''
    export PATH="$PWD/dist/build/cabal2nix:$PATH"
    export HOME="$TMPDIR/home"
  '';
  homepage = "https://github.com/nixos/cabal2nix#readme";
  description = "Convert Cabal files into Nix build instructions";
  license = stdenv.lib.licenses.bsd3;
}
