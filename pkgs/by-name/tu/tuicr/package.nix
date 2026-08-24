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
  version = "0.23.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "agavra";
    repo = "tuicr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SvRvoQN9b4pXg4rPFnYI2Yeg3SAZKyjYknR2AzfoHnY=";
  };

  cargoHash = "sha256-1h8jDRssVA7gNfHB/9Uh1QWOsNF+aUBU698P/qLbyeY=";

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
