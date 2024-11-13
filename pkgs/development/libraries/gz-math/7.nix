{
  callPackage,
  gz-cmake_3,
  gz-utils_2,
}:

(callPackage ./generic.nix {
  gz-cmake = gz-cmake_3;
  gz-utils = gz-utils_2;
})
  {
    version = "7.5.1";
    hash = "sha256-RxCZiU0h0skVPBSn+PMtkdwEabmTKl+0PYDpl9SQoq8=";
  }
