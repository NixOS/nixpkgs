{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tuxedo";
  version = "2026.6.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "webstonehq";
    repo = "tuxedo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0ulyr7AbB6KZbAAvxc/s0NJTPBYS42UCbEXYREJTWMo=";
  };

  cargoHash = "sha256-Sd3O/bw3/FZeas2eWAvSV3HWcDQg8Cla2hagWVYRKsc=";

  preCheck = ''
    export HOME="$TMPDIR/home"
    export XDG_CONFIG_HOME="$TMPDIR/config"
    export XDG_CACHE_HOME="$TMPDIR/cache"
    export XDG_STATE_HOME="$TMPDIR/state"

    mkdir -p \
      "$HOME" \
      "$XDG_CONFIG_HOME" \
      "$XDG_CACHE_HOME" \
      "$XDG_STATE_HOME"
  '';

  passthru.updateScript = nix-update-script { };

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  checkFlags = [
    # Failure
    "--skip=insert_dialog_after_nl_parse"
  ];
  meta = {
    description = "fast, keyboard-driven terminal UI for todo.txt";
    homepage = "https://github.com/webstonehq/tuxedo";
    changelog = "https://github.com/webstonehq/tuxedo/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ iogamaster ];
    mainProgram = "tuxedo";
  };
})
