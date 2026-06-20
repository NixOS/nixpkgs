{
  lib,
  stdenv,
  fetchFromGitLab,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "warmup-s3-archives";
  version = "1.2.1";

  src = fetchFromGitLab {
    owner = "philipmw";
    repo = "warmup-s3-archives";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AI/PD7Kkzzg5IqBy0uRM1QG7+pzhjECo+ad2I0pUkKo=";
  };

  cargoHash = "sha256-2LOJ+f6SIkzPM+ucWU+7COUwo2Pvti7hL8k0+ry29SM=";

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://gitlab.com/philipmw/warmup-s3-archives";
    changelog = "https://gitlab.com/philipmw/warmup-s3-archives/-/releases/v${finalAttrs.version}";
    description = "A warmup program that facilitates restoring archived objects from Amazon S3 Glacier storage classes";
    mainProgram = "warmup-s3-archives";
    platforms = lib.platforms.all;
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.pmw ];
  };
})
