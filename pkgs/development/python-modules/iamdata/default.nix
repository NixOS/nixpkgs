{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "iamdata";
  version = "0.1.202510131";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cloud-copilot";
    repo = "iam-data-python";
    tag = "v${version}";
    hash = "sha256-6b+c7vCZPU2Ze75SQvimU3VvN0TV1lWpIzzO6jO1SL4=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "iamdata" ];

  enabledTestPaths = [ "iamdata/tests/*.py" ];

  meta = {
    description = "Module for utilizing AWS IAM data for Services, Actions, Resources, and Condition Keys";
    homepage = "https://github.com/cloud-copilot/iam-data-python";
    changelog = "https://github.com/cloud-copilot/iam-data-python/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
