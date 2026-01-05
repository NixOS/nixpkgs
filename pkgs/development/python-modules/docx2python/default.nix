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
  version = "3.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ShayHill";
    repo = "docx2python";
    tag = version;
    hash = "sha256-u1zOMfYMhmBsvUcfG7UEMvKT9U5XEkBalGtMOgN8RCU=";
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
