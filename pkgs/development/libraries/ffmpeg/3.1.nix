{ stdenv, callPackage
# Darwin frameworks
, Cocoa, CoreMedia
, ...
}@args:

callPackage ./generic.nix (args // rec {
  version = "${branch}.3";
  branch = "3.1";
  sha256 = "0f4ajs0c4088nkal4gqagx05wfyhd1izfxmzxxsdh56ibp38kg2q";
  darwinFrameworks = [ Cocoa CoreMedia ];
  patches = stdenv.lib.optional stdenv.isDarwin ./sdk_detection.patch;
})
