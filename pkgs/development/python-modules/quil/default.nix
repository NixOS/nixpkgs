{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  rustPlatform,
  numpy,
  pytestCheckHook,
  syrupy,
  libiconv,
}:

buildPythonPackage rec {
  pname = "quil";
  version = "0.11.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "rigetti";
    repo = "quil-rs";
    rev = "quil-py/v${version}";
    hash = "sha256-I8LV7lqJP2xc8eVxMbixeHMRYiTpmpSahfA3WWRjoHA=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    name = "${pname}-${version}";
    inherit src;
    hash = "sha256-U9AVJ4i9E0TeG5cPxdx9hJcMKkZvUXcRfZF7VkM7ddI=";
  };

  buildAndTestSubdir = "quil-py";

  build-system = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

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

  disabledTests = [
    # Syrupy snapshot needs to be regenerated
    "test_filter_instructions"
  ];

  meta = {
    changelog = "https://github.com/rigetti/quil-rs/blob/${src.rev}/quil-py/CHANGELOG.md";
    description = "Python package for building and parsing Quil programs";
    homepage = "https://github.com/rigetti/quil-rs/tree/main/quil-py";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
