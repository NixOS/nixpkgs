{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cryptography,
  charset-normalizer,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
  ocrmypdf,
}:

buildPythonPackage rec {
  pname = "pdfminer-six";
  version = "20250506";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pdfminer";
    repo = "pdfminer.six";
    tag = version;
    hash = "sha256-BE/HMl/e1KnkSc2jXU5Du5FMF+rCBv5AJ7a88oFrBgM=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    charset-normalizer
    cryptography
  ];

  postInstall = ''
    for file in "$out/bin/"*.py; do
      mv "$file" "''${file%.py}"
    done
  '';

  pythonImportsCheck = [
    "pdfminer"
    "pdfminer.high_level"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # The binary file samples/contrib/issue-1004-indirect-mediabox.pdf is
    # stripped from fix-dereference-MediaBox.patch.
    "test_contrib_issue_1004_mediabox"
  ];

  passthru = {
    tests = {
      inherit ocrmypdf;
    };
  };

  meta = {
    changelog = "https://github.com/pdfminer/pdfminer.six/blob/${src.rev}/CHANGELOG.md";
    description = "PDF parser and analyzer";
    homepage = "https://github.com/pdfminer/pdfminer.six";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ psyanticy ];
  };
}
