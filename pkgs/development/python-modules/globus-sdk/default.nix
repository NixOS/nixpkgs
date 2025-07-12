{
  lib,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  flaky,
  pyjwt,
  pytestCheckHook,
  pythonOlder,
  requests,
  responses,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "globus-sdk";
  version = "3.59.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "globus";
    repo = "globus-sdk-python";
    tag = version;
    hash = "sha256-95CcuKCGjFezFpz7UJaA/j9ubFNaNkDQsPnwrt1ZyvA=";
  };

  build-system = [ setuptools ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  dependencies = [
    cryptography
    requests
    pyjwt
  ] ++ lib.optionals (pythonOlder "3.10") [ typing-extensions ];

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [
    flaky
    responses
  ];

  pythonImportsCheck = [ "globus_sdk" ];

  meta = {
    description = "Interface to Globus REST APIs, including the Transfer API and the Globus Auth API";
    homepage = "https://github.com/globus/globus-sdk-python";
    changelog = "https://github.com/globus/globus-sdk-python/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
  };
}
