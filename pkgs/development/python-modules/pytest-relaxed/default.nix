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
  version = "2.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Szc8x1Rmb/YPVCWmnLQUZCwqEc56RsjOBmpzjkCSyjk=";
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
    maintainers = with maintainers; [ costrouc ];
  };
}
