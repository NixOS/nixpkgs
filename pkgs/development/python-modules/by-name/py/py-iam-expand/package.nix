{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  iamdata,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "py-iam-expand";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "prowler-cloud";
    repo = "py-iam-expand";
    tag = version;
    hash = "sha256-P6PWf7qkc/8/BeRycYgvFApIaUrbhKq4h718Nrs817U=";
  };

  build-system = [ poetry-core ];

  dependencies = [ iamdata ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "py_iam_expand" ];

  meta = {
    description = "Module to expand and deobfuscate AWS IAM actions";
    homepage = "https://github.com/prowler-cloud/py-iam-expand";
    changelog = "https://github.com/prowler-cloud/py-iam-expand/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
