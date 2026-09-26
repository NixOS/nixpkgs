{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  portpicker,
  pytest,
  scim2-server,
  pytestCheckHook,
  scim2-client,
  cacert,
}:

buildPythonPackage rec {
  pname = "pytest-scim2-server";
  version = "0.1.6";

  pyproject = true;

  # Pypi doesn't link a VCS repository
  src = fetchPypi {
    pname = "pytest_scim2_server";
    inherit version;
    hash = "sha256-Diu8TPPELQG30NZvafI/t7IR+HzkI0sPsjcUFxwVPLw=";
  };

  build-system = [ hatchling ];

  dependencies = [
    portpicker
    pytest
    scim2-server
  ];

  nativeCheckInputs = [
    pytestCheckHook
    scim2-client
  ]
  ++ scim2-client.optional-dependencies.httpx;

  env.SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  pythonImportsCheck = [ "pytest_scim2_server" ];

  meta = {
    homepage = "https://pypi.org/project/pytest-scim2-server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ erictapen ];
  };
}
