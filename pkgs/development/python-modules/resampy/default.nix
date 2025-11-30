{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  numba,
  numpy,
  optuna,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  scipy,
}:

buildPythonPackage rec {
  pname = "resampy";
  version = "0.4.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bmcfee";
    repo = "resampy";
    tag = version;
    hash = "sha256-LOWpOPAEK+ga7c3bR15QvnHmON6ARS1Qee/7U/VMlTY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    numba
  ];

  optional-dependencies.design = [ optuna ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
    scipy
  ];

  disabledTests = lib.optionals (stdenv.hostPlatform.system == "aarch64-linux") [
    # crashing the interpreter
    "test_quality_sine_parallel"
    "test_resample_nu_quality_sine_parallel"
  ];

  pythonImportsCheck = [ "resampy" ];

  meta = with lib; {
    description = "Efficient signal resampling";
    homepage = "https://github.com/bmcfee/resampy";
    license = licenses.isc;
    maintainers = [ ];
  };
}
