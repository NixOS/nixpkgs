{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zonetimeline-tui";
  version = "0.4.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "findyourexit";
    repo = "zonetimeline-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xOaj0GvGaLLSUb4+raiZSv0ZWuFBsw7EjlrFollOBvw=";
  };

  cargoHash = "sha256-3K4IQmhPm0ov+fUP4SZ8HKAroWBvwtsMAmjfMPm4X0g=";

  checkFlags = [
    # Needs access to the machine's /etc/localtime.
    "--skip=display_label_for_local_resolves_iana_name_with_suffix"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A terminal tool for visually comparing time zones — built for distributed teams";
    longDescription = ''
      See at a glance where working hours overlap across zones, find meeting slots without mental arithmetic, and manage your zone list interactively.
      Ships as a single binary with both a rich TUI and a plain-text mode for scripts and pipes.
    '';
    homepage = "https://github.com/findyourexit/zonetimeline-tui";
    changelog = "https://github.com/findyourexit/zonetimeline-tui/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      adda
    ];
    mainProgram = "ztl";
  };
})
