{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  poetry-core,
  markdown-it-py,
  pytest,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-markdown-docs";
  version = "0.5.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "modal-com";
    repo = "pytest-markdown-docs";
    tag = "v${version}";
    hash = "sha256-mclN28tfPcoFxswECjbrkeOI51XXSqUXfbvuSHrd7Sw=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    markdown-it-py
    pytest
  ];

  pythonImportsCheck = [ "pytest_markdown_docs" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Run pytest on markdown code fence blocks";
    homepage = "https://github.com/modal-com/pytest-markdown-docs";
    license = licenses.mit;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
