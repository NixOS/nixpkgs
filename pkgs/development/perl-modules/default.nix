# inspired by pkgs/development/lua-modules/default.nix
{ buildPerl
, callPackage
, config
, lib
, overrides ? (self: super: { })
, perl
, pkgs
}:

with lib;
let
  initialPackages = (
    callPackage ../../top-level/perl-packages.nix {
      inherit perl pkgs buildPerl;
    }
  );
  configOverrides = self: super:
    (config.perlPackageOverrides or (pkgs: { })) pkgs;
in
makeExtensible
  (extends overrides
    (extends configOverrides
      initialPackages))
