{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  numpy,
  pytestCheckHook,
  syrupy,
}:

buildPythonPackage rec {
  pname = "quil";
  version = "0.35.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rigetti";
    repo = "quil-rs";
    tag = "quil-rs/v${version}";
    hash = "sha256-QWW8+cup81eyedDTU3jgslNanaj0+D2jI5XQMS3ZUIo=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-cIWnTuxoFqkl+0W6NH9DwNokq7RKdNggFLwPYgkbHho=";
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
