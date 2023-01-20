{ callPackage
# Darwin frameworks
, Cocoa, CoreMedia, VideoToolbox
, stdenv, lib
, ...
}@args:

callPackage ./generic.nix (rec {
  version = "4.4.2";
  branch = version;
  sha256 = "sha256-+YpIJSDEdQdSGpB5FNqp77wThOBZG1r8PaGKqJfeKUg=";
  darwinFrameworks = [ Cocoa CoreMedia VideoToolbox ];
} // args)
