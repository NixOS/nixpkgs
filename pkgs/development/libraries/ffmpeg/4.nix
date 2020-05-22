{ stdenv, callPackage, fetchpatch
# Darwin frameworks
, Cocoa, CoreMedia, VideoToolbox
, ...
}@args:

callPackage ./generic.nix (rec {
  version = "4.2.3";
  branch = "4.2";
  sha256 = "0pkrariwjv25k7inwshch7b5820ly3hsp991amyb60rkqc8v4zi1";
  darwinFrameworks = [ Cocoa CoreMedia VideoToolbox ];
} // args)
