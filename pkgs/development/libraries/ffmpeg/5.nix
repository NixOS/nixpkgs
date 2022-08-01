{ callPackage
# Darwin frameworks
, Cocoa, CoreMedia, VideoToolbox
, ...
}@args:

callPackage ./generic.nix (rec {
  version = "5.1";
  branch = version;
  sha256 = "sha256-MrVvsBzpDUUpWK4l6RyVZKv0ntVFPBJ77CPGPlMKqPo=";
  darwinFrameworks = [ Cocoa CoreMedia VideoToolbox ];
} // args)
