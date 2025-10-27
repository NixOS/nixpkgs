{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  scim2-models,
  pytestCheckHook,
  portpicker,
  pytest-httpserver,
  pytest-asyncio,
  scim2-server,
  httpx,
  werkzeug,
  cacert,
}:

buildPythonPackage rec {
  pname = "scim2-client";
  version = "0.6.1";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-scim";
    repo = "scim2-client";
    tag = version;
    hash = "sha256-XwoYyROGP5xrHL6jqYmACkYS7N8bo7ve55H9najpWvE=";
  };

  build-system = [ hatchling ];

  dependencies = [ scim2-models ];

  nativeCheckInputs = [
    pytestCheckHook
    portpicker
    pytest-httpserver
    pytest-asyncio
    scim2-server
    werkzeug
    cacert
  ]
  ++ optional-dependencies.httpx;

  pythonImportsCheck = [ "scim2_client" ];

  optional-dependencies = {
    httpx = [ httpx ];
    werkzeug = [ werkzeug ];
  };

  meta = {
    description = "Pythonically build SCIM requests and parse SCIM responses";
    homepage = "https://scim2-client.readthedocs.io/";
    changelog = "https://github.com/python-scim/scim2-client/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ erictapen ];
  };
}
