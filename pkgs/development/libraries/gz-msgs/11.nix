{
  callPackage,
  fetchpatch,
  gz-cmake_4,
  gz-math_8,
  gz-utils_3,
}:

(callPackage ./generic.nix {
  gz-cmake = gz-cmake_4;
  gz-math = gz-math_8;
  gz-utils = gz-utils_3;
})
  {
    version = "11.0.2";
    hash = "sha256-PUhFOmVPRiOVWfOjAU8z8dcxKPdcoTrgRwDGXP/vsUs=";
  }
