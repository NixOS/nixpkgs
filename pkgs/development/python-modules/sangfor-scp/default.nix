{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pycryptodome,
  pytestCheckHook,
  requests,
  setuptools,
  urllib3,
}:

buildPythonPackage (finalAttrs: {
  pname = "sangfor-scp";
  version = "0.4.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "erelbi";
    repo = "sangfor-scp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jq/BGahQM9r0HX0u9DnswJMsu5wCg/s3kP/9O8aoMGg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    urllib3
  ];

  optional-dependencies = {
    token-auth = [ pycryptodome ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.token-auth;

  enabledTestPaths = [ "tests" ];

  pythonImportsCheck = [ "sangfor_scp" ];

  meta = {
    description = "Python client for the Sangfor Cloud Platform (SCP) Open-API";
    homepage = "https://github.com/erelbi/sangfor-scp";
    changelog = "https://github.com/erelbi/sangfor-scp/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ erelbi ];
    mainProgram = "scp-health";
  };
})
