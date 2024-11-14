{
  callPackage,
  gz-cmake_3,
  gz-common_5,
  gz-msgs_10,
}:

# TODO: Incomplete, untested
(callPackage ./generic.nix {
  gz-cmake = gz-cmake_3;
  gz-common = gz-common_5;
  gz-msgs = gz-msgs_10;
})
  {
    version = "9.1.0";
  }
