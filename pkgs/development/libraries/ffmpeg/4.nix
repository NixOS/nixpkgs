{ stdenv, callPackage, fetchpatch
# Darwin frameworks
, Cocoa, CoreMedia, VideoToolbox
, ...
}@args:

callPackage ./generic.nix (args // rec {
  version = "4.2.1";
  branch = "4.2";
  sha256 = "090naa6rj46pzkgh03bf51hbqdz356qqckr2pw6pykc6ysiryak8";
  darwinFrameworks = [ Cocoa CoreMedia VideoToolbox ];
})
