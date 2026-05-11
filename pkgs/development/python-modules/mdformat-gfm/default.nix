{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,

  # dependencies
  markdown-it-py,
  mdformat,
  mdit-py-plugins,
  wcwidth,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mdformat-gfm";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hukkin";
    repo = "mdformat-gfm";
    tag = finalAttrs.version;
    hash = "sha256-Vijt5P3KRL4jkU8AI2lAsJkvFne/l3utUkjHUs8PQHI=";
  };

  build-system = [
    flit-core
  ];

  dependencies = [
    markdown-it-py
    mdformat
    mdit-py-plugins
    wcwidth
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mdformat_gfm" ];

  meta = {
    description = "Mdformat plugin for GitHub Flavored Markdown compatibility";
    homepage = "https://github.com/hukkin/mdformat-gfm";
    changelog = "https://github.com/hukkin/mdformat-gfm/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      aldoborrero
      polarmutex
    ];
  };
})
