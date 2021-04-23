{ callPackage, fetchpatch
# Darwin frameworks
, Cocoa, CoreMedia, VideoToolbox
, ...
}@args:

callPackage ./generic.nix (rec {
  version = "4.3.2";
  branch = "4.3";
  sha256 = "0flik4y7c5kchj65p3p908mk1dsncqgzjdvzysjs12rmf1m6sfmb";
  darwinFrameworks = [ Cocoa CoreMedia VideoToolbox ];
} // args)
