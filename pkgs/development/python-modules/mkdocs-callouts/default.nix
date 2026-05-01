{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  mkdocs,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mkdocs-callouts";
  version = "1.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sondregronas";
    repo = "mkdocs-callouts";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CffhtU5ur/QleVOk2twh+7kbHUB6HWEXt+E1YbI5I94=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    mkdocs
  ];

  pythonImportsCheck = [
    "mkdocs_callouts"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "A simple MkDocs plugin that converts Obsidian callout blocks to mkdocs supported Admonitions";
    homepage = "https://github.com/sondregronas/mkdocs-callouts";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
  };
})
