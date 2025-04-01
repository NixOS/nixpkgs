{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  lark,
  pytestCheckHook,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-hcl2";
  version = "7.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "amplify-education";
    repo = "python-hcl2";
    tag = "v${version}";
    hash = "sha256-ApRsZUXydC+gsBwlkwyhU0mOOKEhR40Gv+sID7J499c=";
  };

  disabled = pythonOlder "3.7";

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ lark ];

  pythonImportsCheck = [ "hcl2" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "A parser for HCL2 written in Python using Lark";
    homepage = "https://github.com/amplify-education/python-hcl2";
    changelog = "https://github.com/amplify-education/python-hcl2/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ shivaraj-bh ];
  };
}
