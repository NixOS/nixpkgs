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
  ];
})
