{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  portpicker,
  pytest,
  scim2-server,
  pytestCheckHook,
  scim2-client,
  cacert,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytest-scim2-server";
  version = "0.3.0";

  pyproject = true;

  # Pypi doesn't link a VCS repository
  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = "pytest-scim2-server";
    tag = finalAttrs.version;
    hash = "sha256-GKIFGuqPeTI6tMo5o08i/twkke95A9YVcNkcymRgGK8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'uv_build>=0.12.13,<0.13.0' 'uv_build'
  '';

  build-system = [ uv-build ];

  dependencies = [
    portpicker
    pytest
    scim2-server
  ];

  nativeCheckInputs = [
    pytestCheckHook
    scim2-client
  ]
  ++ scim2-client.optional-dependencies.httpx2;

  env.SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  pythonImportsCheck = [ "pytest_scim2_server" ];

  meta = {
    homepage = "https://github.com/pytest-dev/pytest-scim2-server";
    changelog = "https://github.com/pytest-dev/pytest-scim2-server/blob/${finalAttrs.src.tag}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ erictapen ];
  };
})
