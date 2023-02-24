{ lib
, fetchPypi
, buildPythonPackage
, pytest
, pythonOlder
}:

buildPythonPackage rec {
  pname = "node-semver";
  version = "0.9.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  nativeCheckInputs = [ pytest ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BKoLABbbwGdI1jeMQtjPgqNDQVvZ/KYoT0iAQdCLM7s=";
  };

  nativeCheckInputs = [
    pytest
  ];

  pythonImportsCheck = [
    "nodesemver"
  ];

  meta = with lib; {
    changelog = "https://github.com/podhmo/python-node-semver/blob/${version}/CHANGES.txt";
    description = "A port of node-semver";
    homepage = "https://github.com/podhmo/python-semver";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
