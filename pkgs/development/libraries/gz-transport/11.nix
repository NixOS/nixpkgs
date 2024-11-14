{
  callPackage,
  ignition-cmake_2,
  ignition-math_6,
  ignition-msgs_8,
  ignition-utils_1,
}:

(callPackage ./generic.nix {
  gz-cmake = ignition-cmake_2;
  gz-math = ignition-math_6;
  gz-msgs = ignition-msgs_8;
  gz-utils = ignition-utils_1;
})
  {
    version = "11.4.1";
    hash = "sha256-wQ/ugKYopWgSaa6tqPrp8oQexPpnA6fa28L383OGNXM=";
  }
