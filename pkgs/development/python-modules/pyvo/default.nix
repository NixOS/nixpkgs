{
  lib,
  buildPythonPackage,
  fetchPypi,
  astropy,
  pillow,
  pytestCheckHook,
  pytest-astropy,
  requests,
  requests-mock,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pyvo";
  version = "1.7";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pvrZ79QQcy0RPlXfQ7AgHJrLLinydTLHG9pW84zmIyA=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    astropy
    requests
  ];

  nativeCheckInputs = [
    pillow
    pytestCheckHook
    pytest-astropy
    requests-mock
  ];

  disabledTestPaths = [
    # touches network
    "pyvo/dal/tests/test_datalink.py"
  ];

  pythonImportsCheck = [ "pyvo" ];

  meta = with lib; {
    description = "Astropy affiliated package for accessing Virtual Observatory data and services";
    homepage = "https://github.com/astropy/pyvo";
    license = licenses.bsd3;
    maintainers = with maintainers; [ smaret ];
  };
}
