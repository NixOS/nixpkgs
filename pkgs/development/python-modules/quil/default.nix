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
  version = "0.10.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "rigetti";
    repo = "quil-rs";
    rev = "quil-py/v${version}";
    hash = "sha256-GJ39pvIqYs2bMGAHJL8OgB0OfmIpo/k3FxorYvdOvhI=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    name = "${pname}-${version}";
    inherit src;
    hash = "sha256-VvnjdCFrpo/rDLNJrHpZoV+E+fQGgNW/nBOvMG91sHQ=";
  };

  buildAndTestSubdir = "quil-py";

  build-system = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  dependencies = [ numpy ];

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
