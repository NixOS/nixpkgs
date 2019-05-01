{ stdenv, callPackage, pkgsi686Linux, ...}:

let
  i686    = pkgsi686Linux.callPackage ./vms.nix {};
  x86_64  = callPackage ./vms-x86_64.nix { };
in

rec {
  cog32 = i686.cog;
  spur32 = i686.spur;
  spur64 = x86_64.spur;
  multi-vm-wrapper  = callPackage ../wrapper { inherit cog32 spur32 spur64; };
}
