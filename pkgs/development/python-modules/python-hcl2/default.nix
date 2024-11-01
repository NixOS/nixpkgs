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
  version = "5.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "amplify-education";
    repo = "python-hcl2";
    rev = "refs/tags/v${version}";
    hash = "sha256-aUPjW3yQci5aG85qIRHPiKiX01cFw8jWKJY5RuRATvQ=";
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
    changelog = "https://github.com/amplify-education/python-hcl2/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ shivaraj-bh ];
  };
}
