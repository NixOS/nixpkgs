{ stdenv, callPackage, fetchpatch
# Darwin frameworks
, Cocoa, CoreMedia
, ...
}@args:

callPackage ./generic.nix (args // rec {
  version = "${branch}";
  branch = "4.0.1";
  sha256 = "0w0nq98sn5jwx982wzg3vfrxv4p0k1fvsksiz9az0rpvwyqr3rby";
  darwinFrameworks = [ Cocoa CoreMedia ];
})
