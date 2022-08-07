{ lib
, buildPythonPackage
, fetchPypi
, astropy
, pillow
, pythonOlder
, pytestCheckHook
, pytest-astropy
, requests
, requests-mock
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pyvo";
  version = "1.3";

  disabled = pythonOlder "3.8"; # according to setup.cfg

  src = fetchPypi {
    inherit pname version;
    sha256 = "846a54a05a8ddb47a8c2cc3077434779b0e4ccc1b74a7a5408593cb673307d67";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    astropy
    requests
  ];

  checkInputs = [
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
