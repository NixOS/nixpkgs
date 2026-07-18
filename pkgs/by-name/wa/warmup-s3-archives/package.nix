{
  lib,
  stdenv,
  fetchFromGitLab,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "warmup-s3-archives";
  version = "1.2.2";

  src = fetchFromGitLab {
    owner = "philipmw";
    repo = "warmup-s3-archives";
    tag = "v${finalAttrs.version}";
    hash = "sha256-B/8OSqKA3tJhjdShiqAqJrTOc8OuSBLfZ1U9xvvP6vQ=";
  };

  cargoHash = "sha256-31p6IfX5VFSz4tNrjgFigsuTsPA3iO6m3QV6KOb2GKQ=";

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
