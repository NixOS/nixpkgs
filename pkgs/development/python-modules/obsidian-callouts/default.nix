{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  markdown,
}:

buildPythonPackage (finalAttrs: {
  pname = "obsidian-callouts";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "GooRoo";
    repo = "obsidian-callouts";
    tag = "v${finalAttrs.version}";
    hash = "sha256-inq/c5rJ8YirwfFrlfhFVe9FqOt/o2Nkv7+EFUoYBXA=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    markdown
  ];

  pythonImportsCheck = [
    "obsidian_callouts"
  ];

  # No tests are available
  doCheck = false;

  meta = {
    description = "A plugin for Python-Markdown that allows you to use callouts as in Obsidian";
    homepage = "https://github.com/GooRoo/obsidian-callouts";
    license = with lib.licenses; [
      bsd3
      cc0
    ];
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "obsidian-callouts";
  };
})
