{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  jsonschema,
  pytestCheckHook,
  python-dateutil,
  requests,
  setuptools,
  typing-extensions,
  websocket-client,
}:

buildPythonPackage rec {
  pname = "ripe-atlas-cousteau";
  version = "2.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "RIPE-NCC";
    repo = "ripe-atlas-cousteau";
    tag = "v${version}";
    hash = "sha256-LB7zKGIK0ju8lPc5aB/xZHUg9ABY34je2CFhXJpaIOY=";
  };

  pythonRelaxDeps = [ "websocket-client" ];

  build-system = [ setuptools ];

  dependencies = [
    python-dateutil
    requests
    typing-extensions
    websocket-client
  ];

  nativeCheckInputs = [
    pytestCheckHook
    jsonschema
  ];

  pythonImportsCheck = [ "ripe.atlas.cousteau" ];

  meta = {
    description = "Python client library for RIPE ATLAS API";
    homepage = "https://github.com/RIPE-NCC/ripe-atlas-cousteau";
    changelog = "https://github.com/RIPE-NCC/ripe-atlas-cousteau/blob/v${version}/CHANGES.rst";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
  };
}
