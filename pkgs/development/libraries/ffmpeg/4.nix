{ stdenv, callPackage, fetchpatch
# Darwin frameworks
, Cocoa, CoreMedia, VideoToolbox
, ...
}@args:

callPackage ./generic.nix (rec {
  version = "4.3";
  branch = "4.3";
  sha256 = "1qnnhd2b0g5sg72pclxs3i8sxzz0raky69k7w9cmpba9zh973s57";
  darwinFrameworks = [ Cocoa CoreMedia VideoToolbox ];
} // args)
