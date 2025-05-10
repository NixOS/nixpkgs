{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage rec {
  pname = "paragraphs";
  version = "1.0.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ShayHill";
    repo = "paragraphs";
    tag = version;
    hash = "sha256-u5/oNOCLdvfQVEIEpraeNLjTUoh3eJQ6qSExnkzTmNw=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "paragraphs"
  ];

  meta = {
    description = "Module to incorporate long strings";
    homepage = "https://github.com/ShayHill/paragraphs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
