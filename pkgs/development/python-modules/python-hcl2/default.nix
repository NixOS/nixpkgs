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
  version = "8.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "amplify-education";
    repo = "python-hcl2";
    tag = "v${version}";
    hash = "sha256-1N1LBJHFBn5HRiNayyISYVpDcxAMrzoxY2PzDf/jKfI=";
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
