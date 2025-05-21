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

buildPythonPackage rec {
  pname = "cramjam";
  version = "2.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "milesgranger";
    repo = "cramjam";
    tag = version;
    hash = "sha256-zM3EIo7KQYWK7W3LSGaY72iYQQcRB84opLqj/lrSwwY=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname src version;
    hash = "sha256-eMVUDF6DWNzdNfzWuwDF0UBbJ5wQU4/DHaNkP/k2SJ8=";
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
    changelog = "https://github.com/milesgranger/cramjam/releases/tag/v${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
