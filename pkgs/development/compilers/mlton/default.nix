{ stdenv, fetchurl, fetchFromGitHub, patchelf, gmp }:
rec {
  mlton20130715 = import ./20130715.nix {
    inherit stdenv fetchurl patchelf gmp;
  };

  mlton20180207Binary = import ./20180207-binary.nix {
    inherit stdenv fetchurl patchelf gmp;
  };
}
