{
  lib,
  stdenv,
  fetchFromGitLab,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "warmup-s3-archives";
  version = "1.3.0";

  src = fetchFromGitLab {
    owner = "philipmw";
    repo = "warmup-s3-archives";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5lPwhN2lbnU+QpB3ou7M3EKrinn99uz9DKqVLqohATc=";
  };

  cargoHash = "sha256-ToZ9hZjW6tvUUsmvU5lkDLbQ2at7Scn6w+jXJupxA84=";

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
