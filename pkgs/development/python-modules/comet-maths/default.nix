{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,
  wheel,

  # dependencies
  matplotlib,
  numdifftools,
  numpy,
  scikit-learn,
  scipy,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "comet-maths";
  version = "1.0.7";
  pyproject = true;

  src = fetchPypi {
    pname = "comet_maths";
    inherit version;
    hash = "sha256-emmkDEtmeLXayMnwFN3lg5cbtV7FrwLXm6Mn3GpbuPc=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    matplotlib
    numdifftools
    numpy
    scikit-learn
    scipy
  ];
  nativeCheckInputs = [
    pytestCheckHook
  ];
  disabledTestPaths = [
    # Requires punpy, which depends on comet_maths. We _have_ to disable this
    # test to avoid a circular dependency chain.
    "comet_maths/interpolation/tests/test_interpolation.py"
  ];

  meta = {
    description = "Mathematical algorithms and tools to use within CoMet toolkit";
    homepage = "https://comet-maths.readthedocs.io/en/latest/";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
