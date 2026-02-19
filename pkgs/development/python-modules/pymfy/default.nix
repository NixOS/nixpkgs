{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  httpretty,
  poetry-core,
  pytestCheckHook,
  requests,
  requests-oauthlib,
}:

buildPythonPackage rec {
  pname = "pymfy";
  version = "0.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tetienne";
    repo = "somfy-open-api";
    tag = "v${version}";
    hash = "sha256-G/4aBtsN20QtQnMiBBQWg0mqrmR8FuU2f9g77qvk8nI=";
  };

  pythonRelaxDeps = [ "requests-oauthlib" ];

  build-system = [ poetry-core ];

  dependencies = [
    requests
    requests-oauthlib
  ];

  nativeCheckInputs = [
    httpretty
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pymfy" ];

  meta = {
    description = "Python client for the Somfy Open API";
    homepage = "https://github.com/tetienne/somfy-open-api";
    changelog = "https://github.com/tetienne/somfy-open-api/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
