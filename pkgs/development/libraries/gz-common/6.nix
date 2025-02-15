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
    version = "6.0.1";
    hash = "sha256-gVyqzyvdGxXKRm0mpiR1nIYvceWwUDMmp85bHTEpZOE=";
  }
)
