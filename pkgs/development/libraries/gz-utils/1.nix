{
  callPackage,
  ignition-cmake_2,
}:

(callPackage ./generic.nix {
  gz-cmake = ignition-cmake_2;
})
  {
    version = "1.5.1";
    hash = "sha256-Ymlw1SBoSlHwxe/4E3jdMy8ECCFNy8YGboqTQi6UIs4=";
  }
