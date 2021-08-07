{ lib, stdenv, fetchFromGitHub, cmake, gtest }:
let
  version = "7.5.0";

  darwin_src = fetchFromGitHub {
    owner = "xtensor-stack";
    repo = "xsimd";
    rev = version;
    sha256 = "eGAdRSYhf7rbFdm8g1Tz1ZtSVu44yjH/loewblhv9Vs=";
    # Avoid requiring apple_sdk. We're doing this here instead of in the patchPhase
    # because this source is directly used in arrow-cpp.
    # pyconfig.h defines _GNU_SOURCE to 1, so we need to stamp that out too.
    # Upstream PR with a better fix: https://github.com/xtensor-stack/xsimd/pull/463
    postFetch = ''
      mkdir $out
      tar -xf $downloadedFile --directory=$out --strip-components=1
      substituteInPlace $out/include/xsimd/types/xsimd_scalar.hpp \
        --replace 'defined(__APPLE__)' 0 \
        --replace 'defined(_GNU_SOURCE)' 0
    '';
  };

  src = fetchFromGitHub {
    owner = "xtensor-stack";
    repo = "xsimd";
    rev = version;
    sha256 = "0c9pq5vz43j99z83w3b9qylfi66mn749k1afpv5cwfxggbxvy63f";
  };
in stdenv.mkDerivation {
  pname = "xsimd";
  inherit version;
  src = if stdenv.hostPlatform.isDarwin then darwin_src else src;

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DBUILD_TESTS=ON" ];

  doCheck = true;
  checkInputs = [ gtest ];
  checkTarget = "xtest";
  GTEST_FILTER = let
      # Upstream Issue: https://github.com/xtensor-stack/xsimd/issues/456
      filteredTests = lib.optionals stdenv.hostPlatform.isDarwin [
        "error_gamma_test/sse_double.gamma"
        "error_gamma_test/avx_double.gamma"
      ];
    in "-${builtins.concatStringsSep ":" filteredTests}";

  meta = with lib; {
    description = "C++ wrappers for SIMD intrinsics";
    homepage = "https://github.com/xtensor-stack/xsimd";
    license = licenses.bsd3;
    maintainers = with maintainers; [ tobim ];
    platforms = platforms.all;
  };
}
