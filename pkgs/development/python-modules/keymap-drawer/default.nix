{
  lib,

  buildPythonPackage,
  fetchFromGitHub,
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
  version = "0.22.0";
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
    hash = "sha256-SPnIfrUA0M9xznjEe60T+0VHh9lCmY4cni9hyqFlZqM=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    pcpp
    platformdirs
    pydantic
    pydantic-settings
    pyparsing
    pyyaml
    tree-sitter
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
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      MattSturgeon
    ];
    mainProgram = "keymap";
  };
}
