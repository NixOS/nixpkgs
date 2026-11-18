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
  httpx2,
  werkzeug,
  cacert,
}:

buildPythonPackage rec {
  pname = "scim2-client";
  version = "0.14.1";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-scim";
    repo = "scim2-client";
    tag = version;
    hash = "sha256-1or/+rRZat53znkT9db2uanEIILMyNfa8u354dvm424=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'uv_build>=0.12.13,<0.14.0' 'uv_build'
  '';

  build-system = [ uv-build ];

  dependencies = [ scim2-models ];

  nativeCheckInputs = [
    pytestCheckHook
    portpicker
    pytest-httpserver
    pytest-asyncio
    (scim2-server.overridePythonAttrs {
      # Avoid circular dependency
      doCheck = false;
    })
    werkzeug
    cacert
  ]
  ++ optional-dependencies.httpx2;

  pythonImportsCheck = [ "scim2_client" ];

  optional-dependencies = {
    httpx2 = [ httpx2 ];
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
