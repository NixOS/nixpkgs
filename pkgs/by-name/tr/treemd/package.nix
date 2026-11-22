{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  oniguruma,
  stdenv,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "treemd";
  version = "0.11.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Epistates";
    repo = "treemd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-55HsSUYOmnxIoPCZ9hLMg3Tb9ywEnyxzMNjXMg8B4ZQ=";
  };

  cargoHash = "sha256-RW/a4j+sZ4r1RZCJty+IPUPSs4khQuTVrkZ+cWS1hvo=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ oniguruma ];

  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    # FSEvents cannot start a stream inside the Darwin build sandbox
    "--skip=tui::watcher::tests::only_events_for_the_watched_file_count"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI/CLI markdown navigator with tree-based structural navigation";
    homepage = "https://github.com/Epistates/treemd";
    changelog = "https://github.com/Epistates/treemd/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "treemd";
  };
})
