{
  lib,
  astropy,
  buildPythonPackage,
  fetchPypi,
  matplotlib,
  numpy,
  pillow,
  pyavm,
  pyregion,
  pytest-astropy,
  pytestCheckHook,
  reproject,
  scikit-image,
  setuptools,
  setuptools-scm,
  shapely,
}:

buildPythonPackage rec {
  pname = "aplpy";
  version = "2.2.0";
  pyproject = true;

  src = fetchPypi {
    pname = "aplpy";
    inherit version;
    hash = "sha256-oUylUM7/6OyEJFrpkr9MjXilXC/ZIdBQ5au4cvyZiA0=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    astropy
    matplotlib
    numpy
    pillow
    pyavm
    pyregion
    reproject
    scikit-image
    shapely
  ];

  nativeCheckInputs = [
    pytest-astropy
    pytestCheckHook
  ];

  preCheck = ''
    OPENMP_EXPECTED=0
  '';

  pythonImportsCheck = [ "aplpy" ];

  meta = with lib; {
    description = "Astronomical Plotting Library in Python";
    homepage = "http://aplpy.github.io";
    license = licenses.mit;
    maintainers = with maintainers; [ smaret ];
  };
}
