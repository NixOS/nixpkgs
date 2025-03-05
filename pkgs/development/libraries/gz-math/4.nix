{
  callPackage,
  ignition-cmake_0,
}:

(callPackage ./generic.nix {
  gz-cmake = ignition-cmake_0;
  gz-utils = null;
})
  {
    version = "4.0.0";
    hash = "sha256-GDydOD/n8Ip6cVCBsLhgzweCgRVQjJCwVqIbV1lvfKM=";
  }
