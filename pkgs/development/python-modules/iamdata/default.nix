{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "iamdata";
  version = "0.1.202611081";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "act-security-labs";
    repo = "iam-data-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0aC/mk7fsJPcpyr2lZp3kh6g+a2tqGezwmcpjKWazVM=";
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
