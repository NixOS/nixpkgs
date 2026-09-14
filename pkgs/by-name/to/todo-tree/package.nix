{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "todo-tree";
  version = "0.6.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "atrtde";
    repo = "todo-tree";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vGC7uvsWkPCwX7Z4wn21hRRbymEAbrnI5CB+crk/iNg=";
  };

  cargoHash = "sha256-869LvnJDDK0WnGa0N9OhU/bW7DINkm/VFmKe3IbCp/o=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line tool to find and display TODO-style comments in your codebase";
    homepage = "https://github.com/atrtde/todo-tree";
    changelog = "https://github.com/atrtde/todo-tree/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "todo-tree";
  };
})
