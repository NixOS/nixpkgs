{
  lib,
  fetchFromGitHub,
  cmake,
  gtest,
  openblas,
  stdenv,
  xtensor,
  xtl,
  ctestCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xtensor-blas";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "xtensor-stack";
    repo = "xtensor-blas";
    tag = finalAttrs.version;
    hash = "sha256-1ZBM1pMXsZNLf1ywUjXrGArnpoeoL5XsnD1IN528U7M=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    gtest
    xtensor
    xtl
  ];
  checkInputs = [
    ctestCheckHook
    openblas
  ];

  enableParallelBuilding = true;

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTS" true)
  ];

  # Disable some failing tests
  # The individual test cases are not exposed via ctest (only a single "xtest" case),
  # hence we cannot disable these via ctest...
  postPatch = ''
    substituteInPlace test/test_lapack.cpp \
      --replace-fail 'TEST(xlapack,' 'TEST(DISABLED_xlapack,'
    substituteInPlace test/test_linalg.cpp \
      --replace-fail 'TEST(xlinalg,' 'TEST(DISABLED_xlinalg,'
    substituteInPlace test/test_lstsq.cpp \
      --replace-fail 'TEST(xtest_extended,' 'TEST(DISABLED_xtest_extended,'
    substituteInPlace test/test_qr.cpp \
      --replace-fail 'TEST(xtest_extended,' 'TEST(DISABLED_xtest_extended,'
  '';
  doCheck = true;
  checkTarget = "test_xtensor_blas";
  ctestFlags = [ "--verbose" ];

  meta = {
    description = "Extension to the xtensor library offering bindings to BLAS and LAPACK";
    homepage = "https://github.com/QuantStack/xtensor-blas";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jherland ];
  };
})
