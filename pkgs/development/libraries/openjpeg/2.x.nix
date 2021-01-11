{ callPackage, fetchpatch, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2.4.0";
  branch = "2.4";
  revision = "v${version}";
  sha256 = "143dvy5g6v6129lzvl0r8mrgva2fppkn0zl099qmi9yi9l9h7yyf";

  extraFlags = [
    "-DOPENJPEG_INSTALL_INCLUDE_DIR=${placeholder "dev"}/include/openjpeg-${branch}"
    "-DOPENJPEG_INSTALL_PACKAGE_DIR=${placeholder "dev"}/lib/openjpeg-${branch}"
  ];

  patches = [
    ./fix-cmake-config-includedir.patch
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/uclouvain/openjpeg/pull/1321.patch";
      sha256 = "1cjpr76nf9g65nqkfnxnjzi3bv7ifbxpc74kxxibh58pzjlp6al8";
    })
  ];
})
