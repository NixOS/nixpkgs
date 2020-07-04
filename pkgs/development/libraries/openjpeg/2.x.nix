{ callPackage, fetchpatch, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2.3.1";
  branch = "2.3";
  revision = "v${version}";
  sha256 = "1dn98d2dfa1lqyxxmab6rrcv52dyhjr4g7i4xf2w54fqsx14ynrb";

  extraFlags = [
    "-DOPENJPEG_INSTALL_INCLUDE_DIR=${placeholder "dev"}/include/openjpeg-${branch}"
    "-DOPENJPEG_INSTALL_PACKAGE_DIR=${placeholder "dev"}/lib/openjpeg-${branch}"
  ];

  patches = [
    ./fix-cmake-config-includedir.patch
    (fetchpatch {
      url = "https://github.com/uclouvain/openjpeg/commit/21399f6b7d318fcdf4406d5e88723c4922202aa3.patch";
      name = "CVE-2019-12973-1.patch";
      sha256 = "161yvnfbzy2016qqapm0ywfgglgs1v8ljnk6fj8d2bwdh1cxxz8f";
    })
    (fetchpatch {
      url = "https://github.com/uclouvain/openjpeg/commit/3aef207f90e937d4931daf6d411e092f76d82e66.patch";
      name = "CVE-2019-12973-2.patch";
      sha256 = "1jkkfw13l7nx4hxdhc7z17f4vfgqcaf09zpl235kypbxx1ygc7vq";
    })
    (fetchpatch {
      url = "https://github.com/uclouvain/openjpeg/commit/024b8407392cb0b82b04b58ed256094ed5799e04.patch";
      name = "CVE-2020-6851.patch";
      sha256 = "1lfwlzqxb69cwzjp8v9lijz4c2qhf3b8m6sq1khipqlgrb3l58xw";
    })
    (fetchpatch {
      url = "https://github.com/uclouvain/openjpeg/commit/05f9b91e60debda0e83977e5e63b2e66486f7074.patch";
      name = "CVE-2020-8112.patch";
      sha256 = "16kykc8wbq9kx9w9kkf3i7snak82m184qrl9bpxvkjl7h0n9aw49";
    })
  ];
})
