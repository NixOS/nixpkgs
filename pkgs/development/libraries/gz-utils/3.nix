{
  callPackage,
  gz-cmake_4,
}:

(callPackage ./generic.nix {
  gz-cmake = gz-cmake_4;
})
  {
    version = "3.0.0";
    hash = "sha256-maq0iGCGbrjVGwBNNIYYSAKXxszwlAJS4FLrGNxsA5c=";
  }
