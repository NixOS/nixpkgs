{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mock,
  setuptools,
  tox,
}:

buildPythonPackage rec {
  pname = "routeros-api";
  version = "0.21.0";
  pyproject = true;

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

  meta = {
    description = "Python API to RouterBoard devices produced by MikroTik";
    homepage = "https://github.com/socialwifi/RouterOS-api";
    changelog = "https://github.com/socialwifi/RouterOS-api/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ quentin ];
  };
}
