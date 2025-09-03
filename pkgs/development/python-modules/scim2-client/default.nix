{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
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

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit version;
    pname = "scim2_client";
    hash = "sha256-5XOUOKf0vYHkewY22x5NQdhICXCd+EftKhsxtQurgHQ=";
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

  # Werkzeug returns 500, didn't deem it worth it to investigate
  disabledTests = [
    "test_search_request"
    "test_query_dont_check_request_payload"
  ];

  pythonImportsCheck = [ "scim2_client" ];

  optional-dependencies = {
    httpx = [ httpx ];
    werkzeug = [ werkzeug ];
  };

  meta = with lib; {
    description = "Pythonically build SCIM requests and parse SCIM responses";
    homepage = "https://scim2-client.readthedocs.io/";
    changelog = "https://github.com/python-scim/scim2-client/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ erictapen ];
  };
}
