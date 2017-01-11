{ stdenv, callPackage
# Darwin frameworks
, Cocoa, CoreMedia
, ...
}@args:

callPackage ./generic.nix (args // rec {
  version = "${branch}.2";
  branch = "3.2";
  sha256 = "0srn788i4k5827sl8vmds6133vjy9ygsmgzwn40n3l5qs5b9l4hb";
  darwinFrameworks = [ Cocoa CoreMedia ];
  patches = stdenv.lib.optional stdenv.isDarwin ./sdk_detection.patch;
})
