{ stdenv, callPackage, pkgsi686Linux, makeWrapper, ...}:

let
  i686    = pkgsi686Linux.callPackage ./vms.nix {};
  native  = callPackage ./vms.nix {};
in

rec {
  cog32 = i686.cog;
  spur32 = i686.spur;
  spur64 = if stdenv.is64bit then native.spur else "none";
  multi-vm-wrapper  = callPackage ../wrapper { inherit cog32 spur32 spur64; };
}
