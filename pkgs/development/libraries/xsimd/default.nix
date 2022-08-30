{ lib, stdenv, fetchFromGitHub, cmake, gtest }:
stdenv.mkDerivation rec {
  pname = "xsimd";
  version = "8.1.0";
  src = fetchFromGitHub {
    owner = "xtensor-stack";
    repo = "xsimd";
    rev = version;
    sha256 = "sha256-Aqs6XJkGjAjGAp0PprabSM4m+32M/UXpSHppCHdzaZk=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DBUILD_TESTS=ON" ];

  doCheck = true;
  checkInputs = [ gtest ];
  checkTarget = "xtest";
  GTEST_FILTER =
    let
      # Upstream Issue: https://github.com/xtensor-stack/xsimd/issues/456
      filteredTests = lib.optionals stdenv.hostPlatform.isDarwin [
        "error_gamma_test/*"
      ];
    in
    "-${builtins.concatStringsSep ":" filteredTests}";

  meta = with lib; {
    description = "C++ wrappers for SIMD intrinsics";
    homepage = "https://github.com/xtensor-stack/xsimd";
    license = licenses.bsd3;
    maintainers = with maintainers; [ tobim ];
    platforms = platforms.all;
  };
}
