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
  version = "1.16.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sondregronas";
    repo = "mkdocs-callouts";
    tag = "v${finalAttrs.version}";
    hash = "sha256-I7KHZgUV67Ff9Nt1z1LVjia9eQ5V+7y24ZepkpooT2w=";
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
