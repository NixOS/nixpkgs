{ callPackage
, fetchpatch
}:

callPackage ./generic.nix {
  version = "3.6.0";
  hash = "sha256-tCwAKoTvY8VCjcTPNwS3DeitflhpKHLr6ygHZDbR6wQ=";

  patches = [
    # https://github.com/Mbed-TLS/mbedtls/pull/9000
    # Remove at next version update
    (fetchpatch {
      name = "fix-darwin-memcpy-error.patch";
      url = "https://github.com/Mbed-TLS/mbedtls/commit/b32d7ae0fee2f906be59780b42a0cd4468a39bd1.patch";
      hash = "sha256-BTkJs9NEkCl+/Q8EwB/LW9uwF95jQOKWmoCK4B/7/sU=";
    })
  ];
}
