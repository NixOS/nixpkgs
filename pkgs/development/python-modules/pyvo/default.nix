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
  version = "1.4";

  disabled = pythonOlder "3.8"; # according to setup.cfg

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-R2ttLoFd6Ic0KZl49dzN5NtWAqPpXRaeki6X8CRGsCw=";
  };

  patches = [
    # Backport Python 3.11 support.
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/astropy/pyvo/pull/385.patch";
      sha256 = "IHf3W9fIT8XFvyM41PUiJkt1j+B3RkX3TS4FOnRUMDk=";
    })
  ];

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
