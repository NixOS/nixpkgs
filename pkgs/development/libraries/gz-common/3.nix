{
  callPackage,
  fetchpatch,
  ignition-cmake_2,
  ignition-math_6,
}:

(
  (callPackage ./generic.nix {
    gz-cmake = ignition-cmake_2;
    gz-math = ignition-math_6;
    gz-utils = null;
  })
  {
    version = "3.16.0";
    hash = "sha256-lK3c+aB+46/Pid9vO/gxUh6zicPHf4u2llvwW6KD0Ec=";
  }
).overrideAttrs
  (finalAttrs: {
    # Fix missing cstdint include
    patches = [
      (fetchpatch {
        url = "https://github.com/gazebosim/gz-common/commit/1243852c4bd8525ffc760a620e7d97f94cc2375c.patch";
        hash = "sha256-Smk1EWcBB520kFmyrs+nka8Fj7asedhqagMDfq2liwY=";
      })
    ];
  })
