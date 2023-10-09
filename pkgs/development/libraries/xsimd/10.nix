{ lib
, stdenv
, fetchFromGitHub
, cmake
, doctest
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xsimd";
  version = "10.0.0";

  src = fetchFromGitHub {
    owner = "xtensor-stack";
    repo = "xsimd";
    rev = finalAttrs.version;
    sha256 = "sha256-+ewKbce+rjNWQ0nQzm6O4xSwgzizSPpDPidkQYuoSTU=";
  };

  nativeBuildInputs = [
    cmake
  ];
  patches = lib.optionals stdenv.isDarwin [
    # https://github.com/xtensor-stack/xsimd/issues/807
    ./disable-test_error_gamma-test.patch
  ] ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
    # https://github.com/xtensor-stack/xsimd/issues/798
    ./disable-polar-test.patch
  ];

  cmakeFlags = [
    "-DBUILD_TESTS=${if (finalAttrs.doCheck && stdenv.hostPlatform == stdenv.buildPlatform) then "ON" else "OFF"}"
  ];

  doCheck = true;
  nativeCheckInputs = [
    doctest
  ];
  checkTarget = "xtest";

  meta = with lib; {
    description = "C++ wrappers for SIMD intrinsics";
    homepage = "https://github.com/xtensor-stack/xsimd";
    license = licenses.bsd3;
    maintainers = with maintainers; [ tobim ];
    platforms = platforms.all;
  };
})
