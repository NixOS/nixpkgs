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

buildPythonPackage (finalAttrs: {
  pname = "baycomp";
  version = "1.0.3";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
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
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
