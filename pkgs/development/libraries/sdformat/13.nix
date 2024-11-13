{
  callPackage,
  gz-cmake_3,
  gz-utils_2,
  gz-math_7,
}:

(callPackage ./generic.nix {
  gz-cmake = gz-cmake_3;
  gz-utils = gz-utils_2;
  gz-math = gz-math_7;
})
  {
    version = "13.8.0";
    hash = "sha256-cqg03I/hd4Pxlawk0wojsWUAScw0NxagHWHvWbEj1Yk=";
  }
