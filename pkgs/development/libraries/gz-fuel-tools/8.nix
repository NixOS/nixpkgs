{
  callPackage,
  gz-cmake_3,
  gz-common_5,
  gz-msgs_9,
}:

# TODO: Incomplete, untested
(callPackage ./generic.nix {
  gz-cmake = gz-cmake_3;
  gz-common = gz-common_5;
  gz-msgs = gz-msgs_9;
})
  {
    version = "8.2.0";
  }
