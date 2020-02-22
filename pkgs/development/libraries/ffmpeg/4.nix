{ stdenv, callPackage, fetchpatch
# Darwin frameworks
, Cocoa, CoreMedia, VideoToolbox
, ...
}@args:

callPackage ./generic.nix (rec {
  version = "4.2.2";
  branch = "4.2";
  sha256 = "0p0f024rxrpk8pgmrprhfywq10rvdhrs0422wwcwlxkgqa3x285n";
  darwinFrameworks = [ Cocoa CoreMedia VideoToolbox ];
} // args)
