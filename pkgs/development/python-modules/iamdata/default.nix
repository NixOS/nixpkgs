{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "iamdata";
  version = "0.1.202602181";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cloud-copilot";
    repo = "iam-data-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6HLwpTFTqS3T6VQ9jwr7+wVv8ARLDbh9a/68txWMvJU=";
  };

  __darwinAllowLocalNetworking = true;

  build-system = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "iamdata" ];

  enabledTestPaths = [ "iamdata/tests/*.py" ];

  meta = {
    description = "Module for utilizing AWS IAM data for Services, Actions, Resources, and Condition Keys";
    homepage = "https://github.com/cloud-copilot/iam-data-python";
    changelog = "https://github.com/cloud-copilot/iam-data-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
