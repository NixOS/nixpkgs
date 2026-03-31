{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  scikit-learn,
  numpy,
  derivative,
  scipy,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "pysindy";
  version = "2.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-NpZZ22MucuZwtkz9ef08C578jjo28MNfTxG4ROhjuwg=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    scikit-learn
    numpy
    derivative
    scipy
    typing-extensions
  ];

  # Tests require optional dependencies like jax
  doCheck = false;

  pythonImportsCheck = [ "pysindy" ];

  meta = {
    description = "Sparse identification of nonlinear dynamical systems";
    license = lib.licenses.mit;
    homepage = "https://pysindy.readthedocs.io/en/latest/";
    maintainers = with lib.maintainers; [ conny ];
  };
}
