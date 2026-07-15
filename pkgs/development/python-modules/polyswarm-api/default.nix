{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  jsonschema,
  pytestCheckHook,
  python-dateutil,
  requests,
  responses,
  setuptools,
  vcrpy,
}:

buildPythonPackage (finalAttrs: {
  pname = "polyswarm-api";
  version = "3.18.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "polyswarm";
    repo = "polyswarm-api";
    tag = finalAttrs.version;
    hash = "sha256-Mrw+/SbDhfVfC651EHcItf2x2/97kj8ePpxfAQYxBXc=";
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

  meta = {
    description = "Library to interface with the PolySwarm consumer APIs";
    homepage = "https://github.com/polyswarm/polyswarm-api";
    changelog = "https://github.com/polyswarm/polyswarm-api/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
