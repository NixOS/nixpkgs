{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "iamdata";
<<<<<<< HEAD
  version = "0.1.202601011";
=======
  version = "0.1.202511271";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cloud-copilot";
    repo = "iam-data-python";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-tDGY7d8rmD4vKyoFmDAYppuF56aHcb5Ry3nMxOv6PRs=";
=======
    hash = "sha256-1kXJ3Lrs5/rIb2kvE9xENf6A8fzB5Dei7yLSVSmeOi0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  __darwinAllowLocalNetworking = true;

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
