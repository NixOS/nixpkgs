{ stdenv, callPackage, Foundation, libobjc }:
callPackage ./generic.nix (rec {
  inherit Foundation libobjc;
  version = "4.0.4.1";
  sha256 = "1ydw9l89apc9p7xr5mdzy0h97g2q6v243g82mxswfc2rrqhfs4gd";
})
