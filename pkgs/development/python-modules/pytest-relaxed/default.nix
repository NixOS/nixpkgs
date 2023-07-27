{ lib
, buildPythonPackage
, decorator
, fetchPypi
, invocations
, invoke
, pytest
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytest-relaxed";
  version = "2.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-U6c3Lj/qpSdAm7QDU/gTxZt2Dl2L1H5vb88YfF2W3Qw=";
  };

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    decorator
  ];

  nativeCheckInputs = [
    invocations
    invoke
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "tests"
  ];

  pythonImportsCheck = [
    "pytest_relaxed"
  ];

  meta = with lib; {
    homepage = "https://pytest-relaxed.readthedocs.io/";
    description = "Relaxed test discovery/organization for pytest";
    changelog = "https://github.com/bitprophet/pytest-relaxed/blob/${version}/docs/changelog.rst";
    license = licenses.bsd0;
    maintainers = with maintainers; [ ];
  };
}
