{
  callPackage,
  fetchpatch,
  ignition-cmake_2,
  ignition-math_6,
  ignition-utils_1,
}:

(
  (callPackage ./generic.nix {
    gz-cmake = ignition-cmake_2;
    gz-math = ignition-math_6;
    gz-utils = ignition-utils_1;
  })
  {
    version = "4.7.0";
    hash = "sha256-y8qp0UVXxSJm0aJeUD64+aG+gfNEboInW7F6tvHYTPI=";
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
