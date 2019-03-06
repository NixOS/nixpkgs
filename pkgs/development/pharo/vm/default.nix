{ stdenv, callPackage, pkgsi686Linux, makeWrapper, ...}:

let
  i686    = pkgsi686Linux.callPackage ./vms-i686.nix {};
  x86_64  = callPackage ./vms-x86_64.nix { };
in

rec {
  cog32 = i686.cog;
  spur32 = if stdenv.is64bit then i686.spur else x86_64.spur;
  spur64 = if stdenv.is64bit then x86_64.spur else "none";
  multi-vm-wrapper  = callPackage ../wrapper { inherit spur64 spur32 cog32; };
}
