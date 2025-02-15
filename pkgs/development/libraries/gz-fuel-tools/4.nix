{
  callPackage,
  ignition-cmake_2,
  ignition-common_3,
  ignition-msgs_5,
}:

(callPackage ./generic.nix {
  gz-cmake = ignition-cmake_2;
  gz-common = ignition-common_3;
  gz-msgs = ignition-msgs_5;
})
  {
    version = "4.8.3";
    hash = "sha256-Fa/xKb5J37OM0p8HB+Iu1cA47BbPBYZkO4z8XhSB5oc=";
  }
