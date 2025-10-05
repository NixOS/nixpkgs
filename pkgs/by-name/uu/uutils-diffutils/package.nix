{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-diffutils";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "diffutils";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IAgrCkhUC2Tkh+OM1lorpmD0GpsHUauLgU0KcmsvKb4=";
  };

  cargoHash = "sha256-SiZIp0rJXl0ZqKaxLPtV1nypxSqKXW+NoFLxCVpW4OY=";

  checkFlags = [
    # called `Result::unwrap()` on an `Err` value: Os { code: 2, kind: NotFound, message: "No such file or directory" }
    "--skip=ed_diff::tests::test_permutations"
    "--skip=ed_diff::tests::test_permutations_reverse"
    "--skip=ed_diff::tests::test_permutations_empty_lines"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/uutils/diffutils/releases/tag/${finalAttrs.version}";
    description = "Drop-in replacement of diffutils in Rust";
    homepage = "https://github.com/uutils/diffutils";
    license = lib.licenses.mit;
    mainProgram = "diffutils";
    maintainers = with lib.maintainers; [ defelo ];
    platforms = lib.platforms.unix;
  };
})
