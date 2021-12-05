{ callPackage
# Darwin frameworks
, Cocoa, CoreMedia, VideoToolbox, stdenv, lib, ... }@args:

callPackage ./generic.nix (rec {
  version = "4.4.1";
  branch = version;
  sha256 = "0hmck0placn12kd9l0wam70mrpgfs2nlfmi8krd135gdql5g5jcg";
  darwinFrameworks = [ Cocoa CoreMedia VideoToolbox ];
} // args)
