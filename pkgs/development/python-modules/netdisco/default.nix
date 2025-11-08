{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  requests,
  setuptools,
  zeroconf,
}:

buildPythonPackage rec {
  pname = "netdisco";
  version = "3.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TbtZBILzd8zEYeAXQnB8y+jx0tGyhXivkdybf+vNy9I=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    zeroconf
  ];

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
