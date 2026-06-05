{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  numpy,
  scipy,
  matplotlib,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "baycomp";
  version = "1.0.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MrJa17FtWyUd259hEKMtezlTuYcJbaHSXvJ3k10l2uw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    scipy
    matplotlib
  ];

  nativeCheckInputs = [ unittestCheckHook ];
  pythonImportsCheck = [ "baycomp" ];

  meta = {
    description = "Library for Bayesian comparison of classifiers";
    homepage = "https://github.com/janezd/baycomp";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.lucasew ];
  };
}
