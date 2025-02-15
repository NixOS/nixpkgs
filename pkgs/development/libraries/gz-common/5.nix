{
  callPackage,
  fetchpatch,
  gz-cmake_4,
  gz-math_8,
  gz-utils_3,
}:

(
  (callPackage ./generic.nix {
    gz-cmake = gz-cmake_4;
    gz-math = gz-math_8;
    gz-utils = gz-utils_3;
  })
  {
    version = "5.7.0";
    hash = "sha256-Oo4dGN2vsVaElKf/KYjjJq6tlYLRPr0/uh6urGxvDdc=";
  }
)
