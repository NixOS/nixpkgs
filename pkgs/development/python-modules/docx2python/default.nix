{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  lxml,
  paragraphs,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
  pythonOlder,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "docx2python";
  version = "3.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ShayHill";
    repo = "docx2python";
    rev = "refs/tags/${version}";
    hash = "sha256-ucLDdfmLAWcGunOKvh8tBQknXTPI1qOqyXgVGjQOGoQ=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    lxml
    paragraphs
    typing-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "docx2python" ];

  meta = with lib; {
    description = "Extract docx headers, footers, (formatted) text, footnotes, endnotes, properties, and images";
    homepage = "https://github.com/ShayHill/docx2python";
    changelog = "https://github.com/ShayHill/docx2python/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
