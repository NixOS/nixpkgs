{ callPackage, fetchpatch }:

callPackage ./generic.nix {
  version = "2.28.10";
  hash = "sha256-09XWds45TFH7GORrju8pVQQQQomU8MlFAq1jJXrLW0s=";

  patches = [
    # cmake 4 compatibility
    (fetchpatch {
      url = "https://github.com/Mbed-TLS/mbedtls/commit/be4af04fcffcfebe44fa12d39388817d9949a9f3.patch";
      hash = "sha256-CbDm6CchzoTia7Wbpbe3bo9CmHPOsxY2d055AfbCS0g=";
    })
  ];
}
