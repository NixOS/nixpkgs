{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  jsonschema,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  requests,
  setuptools,
  typing-extensions,
  websocket-client,
}:

buildPythonPackage rec {
  pname = "ripe-atlas-cousteau";
  version = "2.1.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "RIPE-NCC";
    repo = "ripe-atlas-cousteau";
    tag = "v${version}";
    hash = "sha256-nt5HB/2o1f/rj0yE2xUe31ubWTLg62YisVOkX4uXsDY=";
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

  meta = with lib; {
    description = "Python client library for RIPE ATLAS API";
    homepage = "https://github.com/RIPE-NCC/ripe-atlas-cousteau";
    changelog = "https://github.com/RIPE-NCC/ripe-atlas-cousteau/blob/v${version}/CHANGES.rst";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
