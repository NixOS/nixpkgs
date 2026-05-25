{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,

  # tests
  hypothesis,
  numpy,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "cramjam";
  version = "2.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "milesgranger";
    repo = "cramjam";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vGT57ou9nnCVCw8LR+w+5MV54EqwT2R+ww9acRQk8Lc=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname src version;
    hash = "sha256-evXYLbv+GwSBUJBb0upjQTFtMPdQbKka8KfJltMUmDs=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  nativeCheckInputs = [
    hypothesis
    numpy
    pytest-xdist
    pytestCheckHook
  ];

  env = {
    # Makes tests less flaky by relaxing performance constraints
    # https://github.com/HypothesisWorks/hypothesis/issues/3713
    CI = true;
  };

  disabledTests = [
    # I (@GaetanLepage) cannot reproduce the failure, but it fails consistently on Ofborg with:
    # SyntaxError: could not convert string to float: 'V' - Consider hexadecimal for huge integer literals to avoid decimal conversion limits.
    "test_variants_decompress_into"
  ];

  disabledTestPaths = [
    "benchmarks/test_bench.py"
  ];

  pythonImportsCheck = [ "cramjam" ];

  meta = {
    description = "Thin Python bindings to de/compression algorithms in Rust";
    homepage = "https://github.com/milesgranger/pyrus-cramjam";
    changelog = "https://github.com/milesgranger/cramjam/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ veprbl ];
  };
})
