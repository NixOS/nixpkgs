{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  mock,
  setuptools,
  tox,
}:

buildPythonPackage rec {
  pname = "routeros-api";
  version = "0.21.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "socialwifi";
    repo = "routeros-api";
    tag = version;
    hash = "sha256-1g37fDB+/6bVwgtgE1YzGnUpDaLEfwDpQWoqjHgeeqk=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    mock
    tox
  ];

  pythonImportsCheck = [ "routeros_api" ];

  meta = with lib; {
    description = "Python API to RouterBoard devices produced by MikroTik";
    homepage = "https://github.com/socialwifi/RouterOS-api";
    changelog = "https://github.com/socialwifi/RouterOS-api/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ quentin ];
  };
}
