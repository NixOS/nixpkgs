{
  lib,
  rustPlatform,
  fetchFromGitHub,
  gitMinimal,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tuicr";
  version = "0.25.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "agavra";
    repo = "tuicr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nbjvSRrbJ4LQrn8l0FJ8R5PNpq7gcQR8m78agL59zqs=";
  };

  cargoHash = "sha256-9L1G0O5kE9EOFAQ092R/C9/SC48K0YcD5D2WjEvkeK0=";

  strictDeps = true;

  nativeCheckInputs = [
    gitMinimal
  ];

  checkFlags = [
    # expects to be run inside the upstream git repository
    "--skip=should_return_no_changes_for_clean_repo"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Review AI-generated diffs like a GitHub pull request, right from your terminal";
    homepage = "https://tuicr.dev";
    changelog = "https://github.com/agavra/tuicr/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Br1ght0ne ];
    mainProgram = "tuicr";
  };
})
