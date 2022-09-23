{ callPackage
# Darwin frameworks
, Cocoa, CoreMedia, VideoToolbox
, ...
}@args:

callPackage ./generic.nix (rec {
  version = "5.1.1";
  branch = version;
  sha256 = "sha256-zQ4W+QNCEmbVzN3t97g7nldUrvS596fwbOnkyALwVFs=";
  darwinFrameworks = [ Cocoa CoreMedia VideoToolbox ];
} // args)
