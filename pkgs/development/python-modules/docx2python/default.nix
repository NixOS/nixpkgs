{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools-scm,
  paragraphs,
  lxml,
  pytestCheckHook,
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

  build-system = [ setuptools-scm ];

  dependencies = [
    paragraphs
    lxml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "docx2python" ];

  meta = {
    homepage = "https://github.com/ShayHill/docx2python";
    description = "Extract docx headers, footers, (formatted) text, footnotes, endnotes, properties, and images";
    changelog = "https://github.com/ShayHill/docx2python/blob/${src.rev}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ sigmanificient ];
    license = lib.licenses.mit;
  };
}
