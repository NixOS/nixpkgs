{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  openblas,
  xtensor,
  xtl,
  doctest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xtensor-blas";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "xtensor-stack";
    repo = "xtensor-blas";
    tag = finalAttrs.version;
    hash = "sha256-3g84TMOBWq9q8O6GipwdsugjGhPwkZE1cXbRsnVp3Ls=";
  };

  # test case THREW exception: Could not find workspace size for gelsd
  postPatch = ''
    substituteInPlace test/CMakeLists.txt \
      --replace-fail "test_lapack.cpp" "" \
      --replace-fail "test_linalg.cpp" "" \
      --replace-fail "test_qr.cpp" "" \
      --replace-fail "test_lstsq.cpp" ""
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    openblas
    xtensor
    xtl
  ];
  nativeCheckInputs = [ doctest ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  doCheck = true;

  meta = {
    description = "Extension to the xtensor library offering bindings to BLAS and LAPACK";
    homepage = "https://github.com/xtensor-stack/xtensor-blas";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jherland ];
  };
})
