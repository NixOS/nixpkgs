# This file defines cabal2nix-unstable, used by maintainers/scripts/haskell/regenerate-hackage-packages.sh.
{ mkDerivation, aeson, ansi-wl-pprint, base, bytestring, Cabal
, containers, deepseq, directory, distribution-nixpkgs, fetchzip
, filepath, hackage-db, hopenssl, hpack, language-nix, lens, lib
, monad-par, monad-par-extras, mtl, optparse-applicative, pretty
, process, split, tasty, tasty-golden, text, time, transformers
, yaml
}:
mkDerivation {
  pname = "cabal2nix";
<<<<<<< HEAD
  version = "unstable-2023-08-15";
  src = fetchzip {
    url = "https://github.com/NixOS/cabal2nix/archive/0365d9b77086d26ca5197fb48019cedbb0dce5d2.tar.gz";
    sha256 = "15aia2v05cmblabhb287cf1yqy4dlzw0g905h79fcvkgygnn2ib8";
=======
  version = "unstable-2023-05-05";
  src = fetchzip {
    url = "https://github.com/NixOS/cabal2nix/archive/078350047d358bb450d634d775493aba89b21212.tar.gz";
    sha256 = "0rsdn2zyw0zr6pi3dg6cm3i310alppigdsv20iqpx0dzykkicywj";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  postUnpack = "sourceRoot+=/cabal2nix; echo source root reset to $sourceRoot";
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
  license = lib.licenses.bsd3;
}
