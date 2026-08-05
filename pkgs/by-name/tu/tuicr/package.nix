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
  version = "0.20.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "agavra";
    repo = "tuicr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ByeWD4mC1DiH6L971mC7Qv6zUVmaf2lneewK2ZWXxg8=";
  };

  cargoHash = "sha256-MVDq+78HIwjqQiO7R/ZAXd16Bye0fktxbiRIzEOH7vQ=";

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
