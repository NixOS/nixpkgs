{
  callPackage,
  ignition-cmake_2,
  ignition-math_6,
}:

(callPackage ./generic.nix {
  gz-cmake = ignition-cmake_2;
  gz-utils = null;
  gz-math = ignition-math_6;
})
  {
    version = "9.10.1";
    hash = "sha256-noHdo5SmTEq+Ws+2GmFVvP8y6QfNzl/g82qs56fEOog=";
  }
