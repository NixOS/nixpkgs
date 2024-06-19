{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  scipy,
  scikit-learn,
  matplotlib,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "baycomp";
  version = "1.0.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MrJa17FtWyUd259hEKMtezlTuYcJbaHSXvJ3k10l2uw=";
  };

  propagatedBuildInputs = [
    numpy
    scipy
    matplotlib
  ];

  nativeCheckInputs = [ unittestCheckHook ];
  pythonImportsCheck = [ "baycomp" ];

  meta = {
    description = "A library for Bayesian comparison of classifiers";
    homepage = "https://github.com/janezd/baycomp";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.lucasew ];
  };
}
