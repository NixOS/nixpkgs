{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  lark,
  pytestCheckHook,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-hcl2";
  version = "8.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "amplify-education";
    repo = "python-hcl2";
    tag = "v${version}";
    hash = "sha256-GR1X5VeOL4cyDQCxZUabnK6t43TM13WmbsgSBGWrKRs=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ lark ];

  pythonImportsCheck = [ "hcl2" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Parser for HCL2 written in Python using Lark";
    homepage = "https://github.com/amplify-education/python-hcl2";
    changelog = "https://github.com/amplify-education/python-hcl2/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ shivaraj-bh ];
  };
}
