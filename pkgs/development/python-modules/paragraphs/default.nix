{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "paragraphs";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ShayHill";
    repo = "paragraphs";
    rev = "refs/tags/${version}";
    hash = "sha256-u5/oNOCLdvfQVEIEpraeNLjTUoh3eJQ6qSExnkzTmNw=";
  };

  build-system = [ setuptools-scm ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "paragraphs" ];

  meta = {
    homepage = "https://github.com/ShayHill/paragraphs";
    description = "Incorporate long strings painlessly, beautifully into Python code";
    changelog = "https://github.com/ShayHill/docx2python/blob/${src.rev}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ sigmanificient ];
    license = lib.licenses.mit;
  };
}
