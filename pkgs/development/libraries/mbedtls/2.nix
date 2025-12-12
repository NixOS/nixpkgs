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
    # fix build against Clang >= 20 (https://github.com/Mbed-TLS/mbedtls-framework/pull/173)
    (fetchpatch {
      name = "Add-__attribute__-nonstring-to-remove-unterminated-s.patch";
      url = "https://github.com/Mbed-TLS/mbedtls-framework/commit/e811994babf84e29e56ebf97265f5fefdf18050f.patch";
      hash = "sha256-PGXh7tMnl7VqBOWVZP3UqT5pEd0yh4oszEJNMiVOcGo=";
    })
    # fix build against Clang >= 20 (https://github.com/Mbed-TLS/mbedtls/pull/10215)
    (fetchpatch {
      name = "Add-__attribute__-nonstring-to-remove-unterminated-s.patch";
      url = "https://github.com/Mbed-TLS/mbedtls/commit/2e1399f1e1ed6fa1072cf9584f5771322b0d001b.patch";
      includes = [ "tests/*" ];
      # drop some context in order to apply the backported patch cleanly
      decode = "interdiff -U1 /dev/null -";
      hash = "sha256-OTRnYw7Og6eAsB9pue1jkxO1xnkR48efz5QKjN9H0I8=";
    })
  ];
}
