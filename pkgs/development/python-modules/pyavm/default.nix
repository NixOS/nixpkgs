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
  version = "0.9.8";
  pyproject = true;

  src = fetchPypi {
    pname = "PyAVM";
    inherit version;
    hash = "sha256-zhHCeex1vfgj0MOGEkoVKKXns2+l3U0mSZInk58Rf4g=";
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
