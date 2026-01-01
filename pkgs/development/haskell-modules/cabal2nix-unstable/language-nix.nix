# This file defines language-nix-unstable, used by maintainers/scripts/haskell/regenerate-hackage-packages.sh.
{
  mkDerivation,
  base,
  deepseq,
  fetchzip,
  hspec,
  lens,
  lib,
  parsec-class,
  pretty,
<<<<<<< HEAD
  process,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  QuickCheck,
}:
mkDerivation {
  pname = "language-nix";
<<<<<<< HEAD
  version = "2.3.0-unstable-2025-11-20";
  src = fetchzip {
    url = "https://github.com/NixOS/cabal2nix/archive/459859839cfe4fb352a29c1a72a1c4f0f537a1b8.tar.gz";
    sha256 = "1443hlbz29y2dn22kf91zx7g284zp3l2vgw6jg4wgx66v2sxrqii";
=======
  version = "2.3.0-unstable-2025-11-11";
  src = fetchzip {
    url = "https://github.com/NixOS/cabal2nix/archive/a152152295a9fa6698583e84a2b8c7eee1446296.tar.gz";
    sha256 = "1jpgzyc360g5snvc5ji6wqfvbsc7siwxvhrwafzzfg762niq0c49";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
  postUnpack = "sourceRoot+=/language-nix; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    base
    deepseq
    lens
    parsec-class
    pretty
    QuickCheck
  ];
  testHaskellDepends = [
    base
    hspec
    lens
    parsec-class
    pretty
<<<<<<< HEAD
    process
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    QuickCheck
  ];
  homepage = "https://github.com/NixOS/cabal2nix/tree/master/language-nix#readme";
  description = "Data types and functions to represent the Nix language";
  license = lib.licenses.bsd3;
}
