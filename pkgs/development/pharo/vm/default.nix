{ stdenv, callPackage, pkgsi686Linux, makeWrapper, ...}:

let
  x86_64  = callPackage ./vms.nix { };
in

rec {
  spur64 = if stdenv.is64bit then x86_64.spur else "none";
  multi-vm-wrapper  = callPackage ../wrapper { inherit spur64; };
}
