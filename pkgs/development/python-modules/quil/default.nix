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
  version = "0.36.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rigetti";
    repo = "quil-rs";
    tag = "quil-rs/v${version}";
    hash = "sha256-BaetYkdJ9iv79Q39TuSrU/JBFjqj+fZocIGAgGBXOL8=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-LzPa9HvkzWjR6nwTpUEqcj1QntpYM8yN1zypGH8tIyU=";
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
