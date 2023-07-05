{ lib
, stdenv
, cmake
, fetchFromGitHub
, static ? stdenv.hostPlatform.isStatic
}:

let
  generic = { version, hash }:
    stdenv.mkDerivation rec {
      inherit version;
      pname = "h3";

      src = fetchFromGitHub {
        owner = "uber";
        repo = "h3";
        rev = "v${version}";
        inherit hash;
      };

      nativeBuildInputs = [ cmake ];

      cmakeFlags = [
        "-DBUILD_SHARED_LIBS=${if static then "OFF" else "ON"}"
        "-DBUILD_BENCHMARKS=OFF"
        "-DBUILD_FUZZERS=OFF"
        "-DBUILD_GENERATORS=OFF"
        "-DENABLE_COVERAGE=OFF"
        "-DENABLE_FORMAT=OFF"
        "-DENABLE_LINTING=OFF"
      ];

      meta = with lib; {
        homepage = "https://h3geo.org/";
        description = "Hexagonal hierarchical geospatial indexing system";
        license = licenses.asl20;
        changelog = "https://github.com/uber/h3/raw/v${version}/CHANGELOG.md";
        platforms = platforms.all;
        maintainers = with maintainers; [ kalbasit marsam ];
      };
    };
in
{
  h3_3 = generic {
    version = "3.7.2";
    hash = "sha256-MvWqQraTnab6EuDx4V0v8EvrFWHT95f2EHTL2p2kei8=";
  };

  h3_4 = generic {
    version = "4.1.0";
    hash = "sha256-7qyN73T8XDwZLgMZld7wwShUwoLEi/2gN2oiZX8n5nQ=";
  };
}
