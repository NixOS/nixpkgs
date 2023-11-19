{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
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
  version = "1.4.2";

  disabled = pythonOlder "3.8"; # according to setup.cfg

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Zv4piGWs/XJbxfGHUHctfxuImbjluxd1chUgvtV9lcs=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
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
