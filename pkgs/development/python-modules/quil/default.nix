{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hypothesis,
  rustPlatform,
  numpy,
  pytestCheckHook,
  syrupy,
}:

buildPythonPackage rec {
  pname = "quil";
  version = "0.37.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rigetti";
    repo = "quil-rs";
    tag = "quil-rs/v${version}";
    hash = "sha256-P9CSHbmzPWrr6DYt7mlqxyXuHb1p1CaGArX+pLYm4Ak=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-Cu2wyBF1bjwQkn22JJlMPBSuEn09f5zxebVp8CWI13o=";
  };

  buildAndTestSubdir = "quil-rs";

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
    hypothesis
    pytestCheckHook
    syrupy
  ];

  pytestFlags = [
    "quil-rs/tests_py"
  ];

  meta = {
    changelog = "https://github.com/rigetti/quil-rs/blob/${src.tag}/quil-rs/CHANGELOG.md";
    description = "Python package for building and parsing Quil programs";
    homepage = "https://github.com/rigetti/quil-rs/tree/main/quil-py";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
