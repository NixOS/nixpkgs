{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  iamdata,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "py-iam-expand";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "prowler-cloud";
    repo = "py-iam-expand";
    tag = finalAttrs.version;
    hash = "sha256-qe3eph3bvVy6Yql76e/OecHAXggp/KNLG1k0iWy4K1w=";
  };

  build-system = [ poetry-core ];

  dependencies = [ iamdata ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "py_iam_expand" ];

  meta = {
    description = "Module to expand and deobfuscate AWS IAM actions";
    homepage = "https://github.com/prowler-cloud/py-iam-expand";
    changelog = "https://github.com/prowler-cloud/py-iam-expand/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
