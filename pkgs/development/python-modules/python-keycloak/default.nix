{
  lib,
  aiofiles,
  buildPythonPackage,
  deprecation,
  fetchFromGitHub,
  httpx,
  jwcrypto,
  poetry-core,
  requests,
  requests-toolbelt,
  freezegun,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-keycloak";
  version = "7.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "marcospereirampj";
    repo = "python-keycloak";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3BrXSktN0OYQJRRZ234z06pGHicJOIBUzSdMd6y95L4=";
  };

  postPatch = ''
    # Upstream doesn't set version
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${finalAttrs.version}"'
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aiofiles
    deprecation
    httpx
    jwcrypto
    requests
    requests-toolbelt
  ];

  nativeCheckInputs = [
    freezegun
    pytest-asyncio
    pytestCheckHook
  ];

  # conftest.py requires these variables to be set,
  # even if the respective tests are disabled
  preCheck = ''
    export KEYCLOAK_{HOST,PORT,ADMIN{,_PASSWORD}}=
  '';

  disabledTestPaths = [
    # these tests require a running keycloak instance
    "tests/test_keycloak_openid.py"
    "tests/test_keycloak_admin.py"
    "tests/test_keycloak_uma.py"
    # requires docker
    "tests/test_pkce_flow.py"
  ];

  pythonImportsCheck = [ "keycloak" ];

  meta = {
    description = "Provides access to the Keycloak API";
    homepage = "https://github.com/marcospereirampj/python-keycloak";
    changelog = "https://github.com/marcospereirampj/python-keycloak/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
