{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  apricot-select,
  networkx,
  numpy,
  scikit-learn,
  scipy,
  torch,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pomegranate";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "pomegranate";
    owner = "jmschrei";
    tag = "v${version}";
    hash = "sha256-p2Gn0FXnsAHvRUeAqx4M1KH0+XvDl3fmUZZ7MiMvPSs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    apricot-select
    networkx
    numpy
    scikit-learn
    scipy
    torch
  ];

  pythonImportsCheck = [ "pomegranate" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
    # AssertionError: Arrays are not almost equal to 6 decimals
    "--deselect=tests/distributions/test_normal_full.py::test_fit"
    "--deselect=tests/distributions/test_normal_full.py::test_from_summaries"
    "--deselect=tests/distributions/test_normal_full.py::test_serialization"
  ];

  disabledTests = [
    # AssertionError: Arrays are not almost equal to 6 decimals
    "test_sample"
  ];

  meta = {
    description = "Probabilistic and graphical models for Python, implemented in cython for speed";
    homepage = "https://github.com/jmschrei/pomegranate";
    changelog = "https://github.com/jmschrei/pomegranate/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rybern ];
  };
}
