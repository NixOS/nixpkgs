{ stdenv, callPackage
# Darwin frameworks
, Cocoa, CoreMedia
, ...
}@args:

callPackage ./generic.nix (args // rec {
  version = "${branch}.4";
  branch = "3.2";
  sha256 = "194n8hwmz2rpgh2rz8bc3mnxjyj3jh090mqp7k76msg9la9kbyn0";
  darwinFrameworks = [ Cocoa CoreMedia ];
  patches = stdenv.lib.optional stdenv.isDarwin ./sdk_detection.patch;
})
