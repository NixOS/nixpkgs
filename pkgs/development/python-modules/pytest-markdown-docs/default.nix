{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  markdown-it-py,
  pytest,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-markdown-docs";
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "modal-com";
    repo = "pytest-markdown-docs";
    tag = "v${version}";
    hash = "sha256-h/EATIbn7sdvWrI2I74WDcfupqfzvB0o5CYqiIus3ZY=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    markdown-it-py
    pytest
  ];

  pythonImportsCheck = [ "pytest_markdown_docs" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Run pytest on markdown code fence blocks";
    homepage = "https://github.com/modal-com/pytest-markdown-docs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
