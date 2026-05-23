{
  lib,
  stdenv,
  fetchFromGitLab,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "warmup-s3-archives";
  version = "1.2.0";

  src = fetchFromGitLab {
    owner = "philipmw";
    repo = "warmup-s3-archives";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SIbynXs81EJz+r5vwl7BIj8UW6sXRWefU1h5D1g4V+4=";
  };

  cargoHash = "sha256-Ck+xhPz2e+FtaaG3DI/7OJXHxjaNajPJg45xGWAjh+w=";

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
