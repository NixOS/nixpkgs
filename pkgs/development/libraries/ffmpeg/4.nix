{ callPackage, fetchpatch
# Darwin frameworks
, Cocoa, CoreMedia, VideoToolbox
, ...
}@args:

callPackage ./generic.nix (rec {
  version = "4.4";
  branch = "4.4";
  sha256 = "03kxc29y8190k4y8s8qdpsghlbpmchv1m8iqygq2qn0vfm4ka2a2";
  darwinFrameworks = [ Cocoa CoreMedia VideoToolbox ];
} // args)
