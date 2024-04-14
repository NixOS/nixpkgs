{ lib, buildPythonPackage, isPy3k, fetchPypi, requests, zeroconf, pytestCheckHook }:

buildPythonPackage rec {
  pname = "netdisco";
  version = "3.0.0";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TbtZBILzd8zEYeAXQnB8y+jx0tGyhXivkdybf+vNy9I=";
  };

  propagatedBuildInputs = [ requests zeroconf ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # Broken due to removed discoverables in https://github.com/home-assistant-libs/netdisco/commit/477db5a1dc93919a6c5bd61b4b1d3c80e75785bd
    "tests/test_xboxone.py"
  ];

  pythonImportsCheck = [
    "netdisco"
    "netdisco.discovery"
  ];

  meta = with lib; {
    description = "Python library to scan local network for services and devices";
    homepage = "https://github.com/home-assistant/netdisco";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
