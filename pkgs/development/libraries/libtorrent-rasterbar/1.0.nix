args@{ callPackage, fetchpatch, ... }:

callPackage (import ./generic.nix {
  version = "1.0.11";
  sha256 = "17p34d3n29q04pvz975gfl1fyj3sg9cl5l6j673xqfq3fpyis58i";
  patches = [
    # Compatibility with new Boost
    (fetchpatch {
      url = "https://github.com/arvidn/libtorrent/commit/7eb3cf6bc6dbada3fa7bb7ff4d5981182813a0e2.patch";
      sha256 = "07agbrii6i8q4wmgpqbln7ldhhadaf5npcinvi6hnyipsr48jbj5";
    })
  ];
}) args
