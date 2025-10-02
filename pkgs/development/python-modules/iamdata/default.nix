{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "iamdata";
  version = "0.1.202510021";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cloud-copilot";
    repo = "iam-data-python";
    tag = "v${version}";
    hash = "sha256-irM3NCm+TtNbHIAsc9Qh8RneJYig/SUJ40jsPy3c07Q=";
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
