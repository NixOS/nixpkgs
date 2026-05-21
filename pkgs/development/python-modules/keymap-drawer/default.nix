{
  lib,

  buildPythonPackage,
  callPackages,
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
buildPythonPackage (finalAttrs: {
  version = "0.23.0";
  pname = "keymap-drawer";
  pyproject = true;
  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "caksoylar";
    repo = "keymap-drawer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yrZidTATnOPacAfdk0gFIgH/3MaZqVOjmzkWNnMa01s=";
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
    tree-sitter
    tree-sitter-grammars.tree-sitter-devicetree
  ];

  nativeCheckInputs = [
    versionCheckHook
  ];

  pythonImportsCheck = [ "keymap_drawer" ];

  passthru.tests = callPackages ./tests {
    keymap-drawer = finalAttrs.finalPackage;
  };
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Module and CLI tool to help parse and draw keyboard layouts";
    homepage = "https://github.com/caksoylar/keymap-drawer";
    changelog = "https://github.com/caksoylar/keymap-drawer/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      MattSturgeon
    ];
    mainProgram = "keymap";
  };
})
