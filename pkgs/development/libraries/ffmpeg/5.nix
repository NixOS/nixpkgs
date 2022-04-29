{ callPackage
# Darwin frameworks
, Cocoa, CoreMedia, VideoToolbox
, ...
}@args:

callPackage ./generic.nix (rec {
  version = "5.0.1";
  branch = version;
  sha256 = "sha256-KN8z1AChwcGyDQepkZeAmjuI73ZfXwfcH/Bn+sZMWdY=";
  darwinFrameworks = [ Cocoa CoreMedia VideoToolbox ];
} // args)
