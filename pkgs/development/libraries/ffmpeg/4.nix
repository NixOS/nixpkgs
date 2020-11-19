{ stdenv, callPackage, fetchpatch
# Darwin frameworks
, Cocoa, CoreMedia, VideoToolbox
, ...
}@args:

callPackage ./generic.nix (rec {
  version = "4.3.1";
  branch = "4.3";
  sha256 = "1nghcpm2r9ir2h6xpqfn9381jq6aiwlkwlnyplxywvkbjiisr97l";
  darwinFrameworks = [ Cocoa CoreMedia VideoToolbox ];
} // args)
