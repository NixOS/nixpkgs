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
  version = "0.9.6";
  pyproject = true;

  src = fetchPypi {
    pname = "PyAVM";
    inherit version;
    hash = "sha256-s7eLPoAHDbY9tPt3RA5zJg+NuTtVV/SqpUUR3NrG8m0=";
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

  meta = with lib; {
    description = "Simple pure-python AVM meta-data handling";
    homepage = "https://astrofrog.github.io/pyavm/";
    license = licenses.mit;
    maintainers = with maintainers; [ smaret ];
  };
}
