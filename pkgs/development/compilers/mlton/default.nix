{ stdenv, fetchurl, fetchgit, patchelf, gmp }:
rec {
  mlton20130715 = import ./20130715.nix {
    inherit stdenv fetchurl patchelf gmp;
  };

  mlton20180207Binary = import ./20180207-binary.nix {
    inherit stdenv fetchurl patchelf gmp;
  };

  mlton20180207 = import ./from-git-source.nix {
    mltonBootstrap = mlton20180207Binary;
    version = "20180207";
    rev = "on-20180207-release";
    sha256 = "00rdd2di5x1dzac64il9z05m3fdzicjd3226wwjyynv631jj3q2a";
    inherit stdenv fetchgit gmp;
  };
}
