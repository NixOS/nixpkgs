{ stdenv, callPackage
# Darwin frameworks
, Cocoa, CoreMedia
, ...
}@args:

callPackage ./generic.nix (args // rec {
  version = "${branch}.6";
  branch = "3.1";
  sha256 = "0c9g9zhrnvbfwwcca35jis7f7njskhzrwa7n7wpd1618cms2kjvx";
  darwinFrameworks = [ Cocoa CoreMedia ];
  patches = stdenv.lib.optional stdenv.isDarwin ./sdk_detection.patch;
})
