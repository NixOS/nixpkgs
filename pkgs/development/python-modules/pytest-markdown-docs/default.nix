{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  markdown-it-py,
  pytest,

  # tests
  mdit-py-plugins,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytest-markdown-docs";
  version = "0.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "modal-com";
    repo = "pytest-markdown-docs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7fGuKTHeaMEbsHD9Zje0ODP2FRWSi0WrCZsPwRYP6rg=";
  };

  build-system = [ hatchling ];

  pythonRelaxDeps = [
    "markdown-it-py"
  ];
  dependencies = [
    markdown-it-py
    pytest
  ];

  pythonImportsCheck = [ "pytest_markdown_docs" ];

  nativeCheckInputs = [
    mdit-py-plugins
    pytestCheckHook
  ];

  meta = {
    description = "Run pytest on markdown code fence blocks";
    homepage = "https://github.com/modal-com/pytest-markdown-docs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
