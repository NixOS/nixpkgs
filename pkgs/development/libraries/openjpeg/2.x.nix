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

    # Fix finding openjpeg.h: https://github.com/uclouvain/openjpeg/pull/1321
    (fetchpatch {
      url = "https://github.com/uclouvain/openjpeg/pull/1321/commits/14f4c27e7c91f745a1dda9991b5deea3cbef2072.patch";
      sha256 = "sha256-lVnzMAy6pSKFnz9eEneDld6zpzfsAmGurPOjTU5Nqnw=";
    })
    (fetchpatch {
      url = "https://github.com/uclouvain/openjpeg/pull/1321/commits/4d0b49edad7fb31ebbf03c60a45b72aaa7b7412b.patch";
      sha256 = "sha256-zU7t6SjmGjt35w875GSQnoTDl8V8yzG1LK2QY0jEnZM=";
    })

  ];
})
