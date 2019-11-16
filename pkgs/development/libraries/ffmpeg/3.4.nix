{ stdenv, callPackage, fetchpatch
# Darwin frameworks
, Cocoa, CoreMedia
, ...
}@args:

callPackage ./generic.nix (args // rec {
  version = branch;
  branch = "3.4.6";
  sha256 = "1s20wzgxxrm56gckyb8cf1lh36hdnkdxvmmnnvdxvia4zb3grf1b";
  darwinFrameworks = [ Cocoa CoreMedia ];
})
