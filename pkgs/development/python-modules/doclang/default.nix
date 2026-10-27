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
  version = "0.8.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "doclang-project";
    repo = "doclang";
    tag = "v${finalAttrs.version}";
    hash = "sha256-H9NijNMcd1FRh6w2pIVnIyY8uRHwXZG5x11ysjXIOwY=";
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
