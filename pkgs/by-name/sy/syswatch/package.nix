{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "syswatch";
  version = "0.14.4";

  src = fetchFromGitHub {
    owner = "matthart1983";
    repo = "syswatch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nds/J4BN61hxuZYKafW/vvyyzOyFWltL57Mm7nECZfs=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-TV1MNGARJlkCuuRBAeo9P1+USK247d6bj8UyZFUcsms=";

  nativeCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  meta = {
    description = "Single-host system diagnostics TUI tool";
    homepage = "https://www.netwatchlabs.com/labs/syswatch";
    changelog = "https://github.com/matthart1983/syswatch/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fab
      tomasrivera
    ];
    mainProgram = "syswatch";
  };
})
