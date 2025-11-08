{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  jsonschema,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  requests,
  responses,
  setuptools,
  vcrpy,
}:

buildPythonPackage rec {
  pname = "polyswarm-api";
  version = "3.14.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "polyswarm";
    repo = "polyswarm-api";
    tag = version;
    hash = "sha256-hf3TKUYkCgKqJYAQLMamcwDBl4uJG/8Gtv/DNHePcZI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    jsonschema
    python-dateutil
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
    vcrpy
  ];

  pythonImportsCheck = [ "polyswarm_api" ];

  meta = with lib; {
    description = "Library to interface with the PolySwarm consumer APIs";
    homepage = "https://github.com/polyswarm/polyswarm-api";
    changelog = "https://github.com/polyswarm/polyswarm-api/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
