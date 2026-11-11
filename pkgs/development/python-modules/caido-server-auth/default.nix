{
  lib,
  buildPythonPackage,
  fetchPypi,
  gql,
  nix-update-script,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "caido-server-auth";
  version = "0.1.3";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "caido_server_auth";
    inherit (finalAttrs) version;
    hash = "sha256-XuqlS9X4y4QMRK+jHLpiiuzMyEXJZScT7RAodHwxsHA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.9.8,<0.10.0" "uv_build"
  '';

  build-system = [ uv-build ];

  dependencies = [
    gql
  ]
  ++ gql.optional-dependencies.aiohttp
  ++ gql.optional-dependencies.websockets;

  pythonImportsCheck = [ "caido_server_auth" ];

  # Module has no tests
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Authenticate with a Caido instance";
    homepage = "https://github.com/caido-community/sdk-py/tree/main/packages/caido-server-auth";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
