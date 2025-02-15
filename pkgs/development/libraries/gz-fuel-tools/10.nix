{
  callPackage,
  gz-cmake_4,
  gz-common_6,
  gz-msgs_11,
}:

(callPackage ./generic.nix {
  gz-cmake = gz-cmake_4;
  gz-common = gz-common_6;
  gz-msgs = gz-msgs_11;
})
  {
    version = "10.0.0";
    hash = "sha256-9WskZnci7D09aW32lzmdtlhRBM+hcmhG6iNgf3OC1js=";
  }
