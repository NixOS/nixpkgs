{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  # build-system
  poetry-core,

  # dependencies
  numpy,
  scipy,
  scikit-learn,
  spectral-derivatives,
  importlib-metadata,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "derivative";
  version = "0.6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "andgoldschmidt";
    repo = "derivative";
    tag = "v${version}";
    hash = "sha256-vsN1zlD9x0CEOtRIwr/DrtkV+OjiyrI8QL9Z8pB3wrY=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    numpy
    scipy
    scikit-learn
    spectral-derivatives
    importlib-metadata
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Numerical differentiation of noisy time series data";
    license = lib.licenses.mit;
    homepage = "https://derivative.readthedocs.io/en/latest/";
    maintainers = with lib.maintainers; [ conny ];
  };
}
