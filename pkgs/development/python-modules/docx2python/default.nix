{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  lxml,
  paragraphs,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "docx2python";
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ShayHill";
    repo = "docx2python";
    tag = version;
    hash = "sha256-seOm5u5PDqDaPytQ8kfVr0CJV/Uv4NtWhmANWcSLp/M=";
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

  meta = {
    description = "Extract docx headers, footers, (formatted) text, footnotes, endnotes, properties, and images";
    homepage = "https://github.com/ShayHill/docx2python";
    changelog = "https://github.com/ShayHill/docx2python/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
