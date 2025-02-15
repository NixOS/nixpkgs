{
  callPackage,
  ignition-cmake_2,
  ignition-common_4,
  ignition-msgs_8,
}:

(callPackage ./generic.nix {
  gz-cmake = ignition-cmake_2;
  gz-common = ignition-common_4;
  gz-msgs = ignition-msgs_8;
})
  {
    version = "7.2.2";
    hash = "sha256-SgU7OuD6OoSvC2UJyZUFjc6IOMY7tukGGg5Ef5pGCPY=";
  }
