{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  writableTmpDirAsHomeHook,
  systemdLibs,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-procps";
  version = "0.0.1-unstable-2026-07-10";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "procps";
    rev = "43414458b44617824ef44a0c5791839c3ab98f28";
    hash = "sha256-Eh8fzCsBIaOmz7Apm0HrBCx446s0ZHjCDQ9FlM2b/gQ=";
  };

  cargoHash = "sha256-yffq2oZ53eNiey/u6kUbXeir0UJZ9LqCm/ysO86qwe0=";

  cargoBuildFlags = [ "--workspace" ];

  nativeBuildInputs = [
    pkg-config
    writableTmpDirAsHomeHook
  ];

  buildInputs = lib.optionals (lib.meta.availableOn stdenv.hostPlatform systemdLibs) [ systemdLibs ];

  checkFlags = [
    # can't run on sandbox
    "--skip=test_pgrep::test_count_with_matching_pattern"
    "--skip=test_pgrep::test_list_full_process_with_empty_cmdline"
    "--skip=test_pgrep::test_terminal_multiple_terminals"
    "--skip=test_pgrep::test_unknown_terminal"
    "--skip=test_pidof"
    "--skip=test_pmap::test_device_permission_denied"
    "--skip=test_pmap::test_extended_permission_denied"
    "--skip=test_pmap::test_permission_denied"
    "--skip=test_ps::test_deselect"
    "--skip=test_ps::test_effective_group_selection"
    "--skip=test_ps::test_effective_user_selection"
    "--skip=test_ps::test_real_group_selection"
    "--skip=test_ps::test_real_user_selection"
    "--skip=test_pkill::test_inverse"
    "--skip=test_pgrep::test_pidfile"
    # pgrep: pattern that searches for process name longer than 15 characters will result in zero matches
    "--skip=test_pgrep::test_pool_workqueue_release"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Rust reimplementation of the procps project";
    homepage = "https://github.com/uutils/procps";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kyehn ];
    platforms = lib.platforms.unix;
  };
})
