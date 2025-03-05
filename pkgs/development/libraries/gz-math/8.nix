{
  callPackage,
  gz-cmake_4,
  gz-utils_3,
}:

(callPackage ./generic.nix {
  gz-cmake = gz-cmake_4;
  gz-utils = gz-utils_3;
})
  {
    version = "8.0.0";
    hash = "sha256-3+846hhsaBaiFLIURlXQx6Z1+VYfp9UZgjdl96JvrRw=";
  }
