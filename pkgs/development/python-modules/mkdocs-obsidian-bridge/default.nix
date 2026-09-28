{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  markdown,
  mkdocs,
  obsidian-callouts,
  obsidian-media,
  pytestCheckHook,
  mkdocs-test,
}:

buildPythonPackage (finalAttrs: {
  pname = "mkdocs-obsidian-bridge";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "GooRoo";
    repo = "mkdocs-obsidian-bridge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-362hEIu84dpfo7L+VsK9/AordnByWZUcakO2mByhZaw=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    markdown
    mkdocs
    obsidian-callouts
    obsidian-media
  ];

  pythonImportsCheck = [
    "mkdocs_obsidian_bridge"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mkdocs-test
  ];

  meta = {
    description = "Use Obsidian’s syntax for your website with this MkDocs plugin";
    homepage = "https://github.com/GooRoo/mkdocs-obsidian-bridge";
    license = with lib.licenses; [
      bsd3
      cc0
    ];
    maintainers = with lib.maintainers; [ drupol ];
  };
})
