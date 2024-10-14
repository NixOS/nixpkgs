{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # build-system
  setuptools-scm,

  # dependencies
  numpy,
  scipy,
  matplotlib,
  pillow,
  pyyaml,
  astropy,
  imageio,
  xxhash,
  numexpr,
  asdf,
  importlib-metadata,
  importlib-resources,

  # tests
  pytest,
  pytest-cov,
  pytestCheckHook,
  mpmath,
  dill,
  flake8,
}:

buildPythonPackage rec {
  pname = "hcipy";
  version = "0.6.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Kt2T6EgCrPTJGiygjmFUh1HH1DthFcZ2mMlnlu0HxsE=";
  };

  nativeBuildInputs =
    [ setuptools-scm ]
    ++ lib.optionals (pythonOlder "3.7") [ importlib-metadata ]
    ++ lib.optionals (pythonOlder "3.9") [ importlib-resources ];

  propagatedBuildInputs = [
    numpy
    scipy
    matplotlib
    pillow
    pyyaml
    astropy
    imageio
    xxhash
    numexpr
    asdf
  ];

  pythonImportsCheck = [ "hcipy" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest
    pytest-cov
    mpmath
    dill
    flake8
  ];

  meta = {
    description = "A framework for performing optical propagation simulations, meant for high contrast imaging, in Python.";
    changelog = "https://github.com/ehpor/hcipy/blob/master/doc/changelog.rst";
    homepage = "https://hcipy.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ BarrOff ];
  };
}
