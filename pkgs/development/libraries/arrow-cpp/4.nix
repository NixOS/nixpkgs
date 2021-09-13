{ callPackage, fetchurl, fetchFromGitHub, ... } @ args:

callPackage ./generic.nix (args // {
  version = "4.0.1";
  srcHash = "sha256-dcy/ona5JcaxyXipIP8vMMSw0/34tRd3kVtvaaIRiW4=";

  arrow-testing = fetchFromGitHub {
    owner = "apache";
    repo = "arrow-testing";
    rev = "d6c4deb22c4b4e9e3247a2f291046e3c671ad235";
    hash = "sha256-MfiJYRYdoa1rqNGV0ab5/JhUPYooyQPuF8NUJSO2kDM=";
  };

  parquet-testing = fetchFromGitHub {
    owner = "apache";
    repo = "parquet-testing";
    rev = "ddd898958803cb89b7156c6350584d1cda0fe8de";
    hash = "sha256-gK04mj1Fuhkf82NDMrXplFa+cr/3Ij7I9VnYfinuJlg=";
  };

  arrow-jemalloc = fetchurl {
    url =
      "https://github.com/jemalloc/jemalloc/releases/download/5.2.1/jemalloc-5.2.1.tar.bz2";
    hash = "sha256-NDMOXOJ2CZ4uiVDZM121qHVomkxqVnUe87HYxTf4h/Y=";
  };

  arrow-mimalloc = fetchurl {
    url =
      "https://github.com/microsoft/mimalloc/archive/v1.6.4.tar.gz";
    hash = "sha256-+mFrGudrVY7DjEEcWa+lK1lj1+escFUZVeBgchLYCq0=";
  };
})
