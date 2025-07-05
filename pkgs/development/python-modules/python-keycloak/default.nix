{
  lib,
  aiofiles,
  async-property,
  buildPythonPackage,
  deprecation,
  fetchFromGitHub,
  httpx,
  jwcrypto,
  poetry-core,
  requests,
  requests-toolbelt,
  pytestCheckHook,
  pytest-asyncio,
  freezegun,
}:

buildPythonPackage rec {
  pname = "python-keycloak";
  version = "5.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "marcospereirampj";
    repo = "python-keycloak";
    tag = "v${version}";
    hash = "sha256-nlvwVvfwOJ3kYkzQ3IDbmLEhFcvOwKasGZyu/wh9b94=";
  };

  postPatch = ''
    # Upstream doesn't set version
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${version}"'
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aiofiles
    async-property
    httpx
    deprecation
    jwcrypto
    requests
    requests-toolbelt
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    freezegun
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
  ];

  pythonImportsCheck = [ "keycloak" ];

  meta = {
    description = "Provides access to the Keycloak API";
    homepage = "https://github.com/marcospereirampj/python-keycloak";
    changelog = "https://github.com/marcospereirampj/python-keycloak/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
