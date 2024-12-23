{ callPackage, fetchpatch }:

callPackage ./generic.nix {
  version = "2.28.9";
  hash = "sha256-/Bm05CvS9t7WSh4qoMconCaD7frlmA/H9YDyJOuGuFE=";
  patches = [
    # https://github.com/Mbed-TLS/mbedtls/pull/9529
    # switch args to calloc in test macro to fix build with gcc-14
    (fetchpatch {
      name = "gcc-14-fixes.patch";
      url = "https://github.com/Mbed-TLS/mbedtls/commit/990a88cd53d40ff42481a2c200b05f656507f326.patch";
      hash = "sha256-Ki8xjm4tbzLZGNUr4hRbf+dlp05ejvl44ddroWJZY4w=";
    })
  ];
}
