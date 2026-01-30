{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  writableTmpDirAsHomeHook,
  systemdLibs,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-procps";
  version = "0.0.1-unstable-2026-01-28";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "procps";
    rev = "0e758a54ff243fbcf3ae6ec1f1761798b148de3a";
    hash = "sha256-IhnxiPDJ+FStCdNQc19C2SwBXQ1qN8VYFGxR8b4o48o=";
  };

  cargoHash = "sha256-sdmZGJYvuQaagEX+ve/1gXveUV7nphDIi5gY8apKGWE=";

  nativeBuildInputs = [
    pkg-config
    writableTmpDirAsHomeHook
  ];

  buildInputs = [ systemdLibs ];

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
