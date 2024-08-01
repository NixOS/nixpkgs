{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  callee,
  cryptography,
  fetchFromGitHub,
  mock,
  poetry-core,
  poetry-dynamic-versioning,
  pyjwt,
  pyopenssl,
  pytestCheckHook,
  pythonOlder,
  requests,
  urllib3,
}:

buildPythonPackage rec {
  pname = "auth0-python";
  version = "4.7.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "auth0";
    repo = "auth0-python";
    rev = "refs/tags/${version}";
    hash = "sha256-udtrvAr8wfg1DbNbBEjA/tlrYhIiXtTFqi4bZCuKI0Q=";
  };

  nativeBuildInputs = [
    poetry-core
    poetry-dynamic-versioning
  ];

  propagatedBuildInputs = [
    aiohttp
    cryptography
    pyjwt
    pyopenssl
    requests
    urllib3
  ] ++ pyjwt.optional-dependencies.crypto;

  nativeCheckInputs = [
    aiohttp
    aioresponses
    callee
    mock
    pytestCheckHook
  ];

  pythonRelaxDeps = [ "cryptography" ];

  disabledTests = [
    # Tries to ping websites (e.g. google.com)
    "can_timeout"
    "test_options_are_created_by_default"
    "test_options_are_used_and_override"
  ];

  pythonImportsCheck = [ "auth0" ];

  meta = with lib; {
    description = "Auth0 Python SDK";
    homepage = "https://github.com/auth0/auth0-python";
    changelog = "https://github.com/auth0/auth0-python/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
