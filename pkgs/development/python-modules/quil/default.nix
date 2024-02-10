{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, rustPlatform
, numpy
, pytestCheckHook
, syrupy
}:

buildPythonPackage rec {
  pname = "quil";
  version = "0.6.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "rigetti";
    repo = "quil-rs";
    rev = "quil-py/v${version}";
    hash = "sha256-SYq0NOzYGJuXFPGjvYzGgKvioCk0hBxLR5S6VFU5d88=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    name = "${pname}-${version}";
    inherit src;
    hash = "sha256-qZY9eQxxlH59DE/RrZFC3G6Pp3IdJupPN5AhUnrKSKs=";
  };

  buildAndTestSubdir = "quil-py";

  preConfigure = ''
    cargo metadata --offline
  '';

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  propagatedBuildInputs = [
    numpy
  ];

  pythonImportsCheck = [ "numpy" ];

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
