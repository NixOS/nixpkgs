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
  # 2.9.1 ships with experimental decoders that were having issues.
  # They were removed afterwards but the change has not been released yet:
  # https://github.com/milesgranger/cramjam/pull/197
  # TODO: update to the next stable release when available
  version = "2.9.1-unstable-2025-01-04";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "milesgranger";
    repo = "cramjam";
    rev = "61564e7761e38e5ec55e7939ccd6a276c2c55d11";
    hash = "sha256-KTYTelQdN5EIJFbyQgrYcayqkAQQSNF+SHqUFFHf1Z8=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname src version;
    hash = "sha256-Jw9zbgcrX3pofW7E8b4xzZYKj3h6ufCVLjv2xD/qONo=";
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
