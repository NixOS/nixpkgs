{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  scipy,
  scikit-base,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pykalman";
  version = "0.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pykalman";
    repo = "pykalman";
    tag = "v${version}";
    hash = "sha256-wV7QxChTPKUBpCNs1afLGvpfbWJx9R8nbC9X973T74U=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    scipy
    scikit-base
  ];

  pythonRelaxDeps = [ "scikit-base" ];

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "pykalman" ];

  meta = with lib; {
    description = "Implementation of the Kalman Filter, Kalman Smoother, and EM algorithm in Python";
    homepage = "https://github.com/pykalman/pykalman";
    license = licenses.bsd2;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
