{
  lib,
  buildPythonPackage,
  pythonAtLeast,
  fetchFromGitHub,
  rustPlatform,
  numpy,
  pytestCheckHook,
  syrupy,
}:

buildPythonPackage rec {
  pname = "quil";
  version = "0.17.0";
  pyproject = true;

  # error: the configured Python interpreter version (3.13) is newer than PyO3's maximum supported version (3.12)
  disabled = pythonAtLeast "3.13";

  src = fetchFromGitHub {
    owner = "rigetti";
    repo = "quil-rs";
    tag = "quil-py/v${version}";
    hash = "sha256-sQvHar52IFVUM+AssPEtBcSGVEma9e909K/5c8H0WQw=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-3qFrsevaVP2tPf0OV0hW6HhhWsj2BM/2sZUvdq1Aa4k=";
  };

  buildAndTestSubdir = "quil-py";

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  dependencies = [ numpy ];

  pythonImportsCheck = [
    "quil.expression"
    "quil.instructions"
    "quil.program"
    "quil.validation"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    syrupy
  ];

  pytestFlags = [
    "quil-py/tests_py"
  ];

  meta = {
    changelog = "https://github.com/rigetti/quil-rs/blob/${src.tag}/quil-py/CHANGELOG.md";
    description = "Python package for building and parsing Quil programs";
    homepage = "https://github.com/rigetti/quil-rs/tree/main/quil-py";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
