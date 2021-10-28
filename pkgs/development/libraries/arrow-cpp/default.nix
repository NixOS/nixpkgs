{ callPackage, fetchurl, fetchFromGitHub, ... } @ args:

callPackage ./generic.nix (args // {
  version = "5.0.0";
  srcHash = "sha256-w7QxPspZTCD3Yag2cZchqvB2AAGviWuuw6tkQg/5kQo=";

  arrow-testing = fetchFromGitHub {
    owner = "apache";
    repo = "arrow-testing";
    rev = "6d98243093c0b36442da94de7010f3eacc2a9909";
    hash = "sha256-n57Fuz2k6sX1o3vYBmC41eRKGnyt9+YL5r3WTHHRRzw=";
  };

  parquet-testing = fetchFromGitHub {
    owner = "apache";
    repo = "parquet-testing";
    rev = "ddd898958803cb89b7156c6350584d1cda0fe8de";
    hash = "sha256-gK04mj1Fuhkf82NDMrXplFa+cr/3Ij7I9VnYfinuJlg=";
  };

  arrow-jemalloc = fetchurl {
    # From
    # ./cpp/cmake_modules/ThirdpartyToolchain.cmake
    # ./cpp/thirdparty/versions.txt
    url =
      "https://github.com/jemalloc/jemalloc/releases/download/5.2.1/jemalloc-5.2.1.tar.bz2";
    hash = "sha256-NDMOXOJ2CZ4uiVDZM121qHVomkxqVnUe87HYxTf4h/Y=";
  };

  arrow-mimalloc = fetchurl {
    # From
    # ./cpp/cmake_modules/ThirdpartyToolchain.cmake
    # ./cpp/thirdparty/versions.txt
    url = "https://github.com/microsoft/mimalloc/archive/v1.7.2.tar.gz";
    hash = "sha256-sZEuNUVlpLaYQQ91g8D4OTSm27Ot5Uq33csVaTIJNr0=";
  };
})
