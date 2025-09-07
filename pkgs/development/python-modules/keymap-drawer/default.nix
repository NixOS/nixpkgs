{
  lib,

  buildPythonPackage,
  fetchFromGitHub,
  fetchPypi,
  pythonOlder,

  nix-update-script,
  pcpp,
  platformdirs,
  poetry-core,
  pydantic,
  pydantic-settings,
  pyparsing,
  pyyaml,
  tree-sitter,
  tree-sitter-grammars,
  versionCheckHook,
}:
let
  version = "0.22.1";
in
buildPythonPackage {
  inherit version;
  pname = "keymap-drawer";
  pyproject = true;
  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "caksoylar";
    repo = "keymap-drawer";
    tag = "v${version}";
    hash = "sha256-X3O5yspEdey03YQ6JsYN/DE9NUiq148u1W6LQpUQ3ns=";
  };

  build-system = [ poetry-core ];

  pythonRelaxDeps = [
    "tree-sitter-devicetree"
  ];

  dependencies = [
    pcpp
    platformdirs
    pydantic
    pydantic-settings
    pyparsing
    pyyaml
    # keymap-drawer currently requires tree-sitter 0.24.0
    # See https://github.com/caksoylar/keymap-drawer/issues/183
    (tree-sitter.overrideAttrs rec {
      version = "0.24.0";
      src = fetchPypi {
        inherit version;
        inherit (tree-sitter) pname;
        hash = "sha256-q9la9lyi9Pfso1Y0M5HtZp52Tzd0i1NSlG8A9/x45zQ=";
      };
    })
    tree-sitter-grammars.tree-sitter-devicetree
  ];

  nativeCheckInputs = [
    versionCheckHook
  ];

  pythonImportsCheck = [ "keymap_drawer" ];

  versionCheckProgram = "${placeholder "out"}/bin/keymap";
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Module and CLI tool to help parse and draw keyboard layouts";
    homepage = "https://github.com/caksoylar/keymap-drawer";
    changelog = "https://github.com/caksoylar/keymap-drawer/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      MattSturgeon
    ];
    mainProgram = "keymap";
  };
}
