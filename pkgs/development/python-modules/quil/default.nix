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
  version = "0.12.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "rigetti";
    repo = "quil-rs";
    rev = "quil-py/v${version}";
    hash = "sha256-OCQp8WKOxyZNMu2waeasSZ4E8VhFqDZcgGbDoMpKeHg=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    name = "${pname}-${version}";
    inherit src;
    hash = "sha256-EmSDjheLEyFr0w6XOvJYdRmGGlv2L/wh3qAN8Nn5lyg=";
  };

  buildAndTestSubdir = "quil-py";

  build-system = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

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
