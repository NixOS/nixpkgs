{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  git,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tuicr";
  version = "0.18.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "agavra";
    repo = "tuicr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cMIUVBEtyS+AB9QqqRSu+Rd+9dyMzw+EmHSIzY2UmiQ=";
  };

  cargoHash = "sha256-ErEpUo9RPOHMHlmlPH2S6jHvnVhi4DKO7EnoMToj5t0=";

  strictDeps = true;

  nativeCheckInputs = [ git ];

  checkFlags = [
    # expects to be run inside the upstream git repository
    "--skip=should_return_no_changes_for_clean_repo"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Review AI-generated diffs like a GitHub pull request, right from your terminal";
    homepage = "https://tuicr.dev";
    changelog = "https://github.com/agavra/tuicr/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Br1ght0ne ];
    mainProgram = "tuicr";
  };
})
