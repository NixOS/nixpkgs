{ callPackage, fetchpatch }:

callPackage ./generic.nix {
  version = "3.5.2";
  hash = "sha256-lVGmnSYccNmRS6vfF/fDiny5cYRPc/wJBpgciFLPUvM=";

  patches = [
    (fetchpatch {
      name = "CVE-2024-28755.patch";
      url = "https://github.com/Mbed-TLS/mbedtls/commit/ad736991bb59211118a29fe115367c24495300c2.patch";
      hash = "sha256-MUnGT2ptlBikpZYL6+cvoF7fOiD2vMK4cbkgevgyl60=";
    })
  ];
}
