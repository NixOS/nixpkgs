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
  version = "0.11.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pykalman";
    repo = "pykalman";
    tag = "v${version}";
    hash = "sha256-8VPSz2pdK5jrVAYgZv64nCKC0E7JtQ1iKFEN0ko4fQE=";
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

  meta = {
    description = "Implementation of the Kalman Filter, Kalman Smoother, and EM algorithm in Python";
    homepage = "https://github.com/pykalman/pykalman";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
