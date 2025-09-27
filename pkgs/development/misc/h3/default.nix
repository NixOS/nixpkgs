{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  withFilters ? false,
}:

let
  generic =
    { version, hash }:
    stdenv.mkDerivation {
      inherit version;
      pname = "h3";

      src = fetchFromGitHub {
        owner = "uber";
        repo = "h3";
        tag = "v${version}";
        inherit hash;
      };

      outputs = [
        "out"
        "dev"
      ];

      nativeBuildInputs = [ cmake ];

      cmakeFlags = [
        (lib.cmakeBool "BUILD_SHARED_LIBS" true)
        (lib.cmakeBool "BUILD_BENCHMARKS" false)
        (lib.cmakeBool "BUILD_FUZZERS" false)
        (lib.cmakeBool "BUILD_GENERATORS" false)
        (lib.cmakeBool "ENABLE_COVERAGE" false)
        (lib.cmakeBool "ENABLE_FORMAT" false)
        (lib.cmakeBool "ENABLE_LINTING" false)
        (lib.cmakeBool "BUILD_FILTERS" withFilters)
      ];

      meta = {
        homepage = "https://h3geo.org/";
        description = "Hexagonal hierarchical geospatial indexing system";
        license = lib.licenses.asl20;
        changelog = "https://github.com/uber/h3/raw/v${version}/CHANGELOG.md";
        platforms = lib.platforms.all;
        maintainers = with lib.maintainers; [ kalbasit ];
      };
    };
in
{
  h3_3 = generic {
    version = "3.7.2";
    hash = "sha256-MvWqQraTnab6EuDx4V0v8EvrFWHT95f2EHTL2p2kei8=";
  };

  h3_4 = generic {
    version = "4.3.0";
    hash = "sha256-DUILKZ1QvML6qg+WdOxir6zRsgTvk+En6yjeFf6MQBg=";
  };
}
