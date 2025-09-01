{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gtest,
  openblas,
  xtensor,
  xtl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xtensor-blas";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "xtensor-stack";
    repo = "xtensor-blas";
    tag = finalAttrs.version;
    hash = "sha256-Lg6MjJbZUCMqv4eSiZQrLfJy/86RWQ9P85UfeIQJ6bk=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    xtensor
    xtl
  ];
  nativeCheckInputs = [
    gtest
    openblas
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  # Disable some failing tests
  env.GTEST_FILTER =
    "-"
    + lib.concatStringsSep ":" [
      "xlapack.*"
      "xlinalg.*"
      "xtest_extended.*"
    ];

  doCheck = true;

  meta = {
    description = "Extension to the xtensor library offering bindings to BLAS and LAPACK";
    homepage = "https://github.com/QuantStack/xtensor-blas";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jherland ];
  };
})
