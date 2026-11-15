{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "iamdata";
  version = "0.1.202611151";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "act-security-labs";
    repo = "iam-data-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Bd6M8Z0MDhhGVqnFjtO7UBf4mRENp/lT9pVIpB+VBMA=";
  };

  __darwinAllowLocalNetworking = true;

  build-system = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "iamdata" ];

  enabledTestPaths = [ "iamdata/tests/*.py" ];

  meta = {
    description = "Module for utilizing AWS IAM data for Services, Actions, Resources, and Condition Keys";
    homepage = "https://github.com/act-security-labs/iam-data-python";
    changelog = "https://github.com/act-security-labs/iam-data-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
