{ lib
, arrow
, buildPythonPackage
, fetchFromGitHub
, hypothesis
, isodate
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "isoduration";
  version = "20.11.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bolsote";
    repo = pname;
    rev = version;
    sha256 = "sha256-6LqsH+3V/K0s2YD1gvmelo+cCH+yCAmmyTYGhUegVdk=";
  };

  propagatedBuildInputs = [
    arrow
  ];

  nativeCheckInputs = [
    hypothesis
    isodate
    pytestCheckHook
  ];

  disabledTestPaths = [
    # We don't care about benchmarks
    "tests/test_benchmark.py"
  ];

  pythonImportsCheck = [
    "isoduration"
  ];

  meta = with lib; {
    description = "Library for operations with ISO 8601 durations";
    homepage = "https://github.com/bolsote/isoduration";
    license = licenses.isc;
    maintainers = with maintainers; [ fab ];
  };
}
