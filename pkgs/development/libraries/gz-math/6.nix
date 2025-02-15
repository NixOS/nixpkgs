{
  callPackage,
  ignition-cmake_2,
}:

(callPackage ./generic.nix {
  gz-cmake = ignition-cmake_2;
  gz-utils = null;
})
  {
    version = "6.15.1";
    hash = "sha256-G6m7mg0xlnXknznLhFPbN/f80DUnWlFksfLAH6339Io=";
  }
