{ stdenv, callPackage, fetchpatch
# Darwin frameworks
, Cocoa, CoreMedia
, ...
}@args:

callPackage ./generic.nix (args // rec {
  version = "${branch}";
  branch = "3.4.4";
  sha256 = "0xmcijcpa7b59ws5ycmnp0a3pjmnpgly0zv8yff6if4p7pw7406f";
  darwinFrameworks = [ Cocoa CoreMedia ];
})
