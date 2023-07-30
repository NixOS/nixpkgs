{ lib, stdenv, fetchFromGitHub, cmake, gtest }:
stdenv.mkDerivation rec {
  pname = "xsimd";
  version = "11.1.0";
  src = fetchFromGitHub {
    owner = "xtensor-stack";
    repo = "xsimd";
    rev = version;
    sha256 = "sha256-l6IRzndjb95hIcFCCm8zmlNHWtKduqy2t/oml/9Xp+w=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DBUILD_TESTS=${if (doCheck && stdenv.hostPlatform == stdenv.buildPlatform) then "ON" else "OFF"}"
  ];

  doCheck = true;
  nativeCheckInputs = [ gtest ];
  checkTarget = "xtest";
  GTEST_FILTER =
    let
      # Upstream Issue: https://github.com/xtensor-stack/xsimd/issues/456
      filteredTests = lib.optionals stdenv.hostPlatform.isDarwin [
        "error_gamma_test/*"
      ];
    in
    "-${builtins.concatStringsSep ":" filteredTests}";

  # https://github.com/xtensor-stack/xsimd/issues/748
  postPatch = ''
    substituteInPlace xsimd.pc.in \
      --replace '$'{prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@
  '';

  meta = with lib; {
    description = "C++ wrappers for SIMD intrinsics";
    homepage = "https://github.com/xtensor-stack/xsimd";
    license = licenses.bsd3;
    maintainers = with maintainers; [ tobim ];
    platforms = platforms.all;
  };
}
