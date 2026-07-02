{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
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
  version = "0.7.5";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-scim";
    repo = "scim2-client";
    tag = version;
    hash = "sha256-vySSYdCd7O7wDB3NDzGizhREwBJQdLfaXk6edJ1HqGE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'uv_build>=0.8.9,<0.9.0' 'uv_build'
  '';

  build-system = [ uv-build ];

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
