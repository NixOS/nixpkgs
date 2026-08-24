{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,
  setuptools-scm,

  # tests
  astropy,
  numpy,
  pillow,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyavm";
  version = "0.9.9";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vA9gXZV8H9bXdlUj/LqLmnI3esbFFGHCqDj+RGALzZo=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    astropy
    numpy
    pillow
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyavm" ];

  meta = {
    description = "Simple pure-python AVM meta-data handling";
    homepage = "https://astrofrog.github.io/pyavm/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ smaret ];
  };
}
