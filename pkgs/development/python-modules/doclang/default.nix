{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  lxml,
  typer,

  # optional-dependencies
  saxonche,

  # tests
  pytestCheckHook,
  python-docx,
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "doclang";
  version = "0.7.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "doclang-project";
    repo = "doclang";
    tag = "v${finalAttrs.version}";
    hash = "sha256-U5QuYCTB2OTugfmvskMnoA71u1DUEVMZTi9H7C7PYEY=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    lxml
    typer
  ];

  optional-dependencies = {
    schematron-saxon = [
      saxonche
    ];
  };

  pythonImportsCheck = [ "doclang" ];

  nativeCheckInputs = [
    pytestCheckHook
    python-docx
    saxonche
    versionCheckHook
  ];

  meta = {
    description = "DocLang spec and reference toolkit";
    homepage = "https://github.com/doclang-project/doclang";
    changelog = "https://github.com/doclang-project/doclang/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "doclang";
  };
})
