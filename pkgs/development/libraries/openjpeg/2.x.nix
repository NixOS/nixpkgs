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
  ];
})
