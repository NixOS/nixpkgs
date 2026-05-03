{
  lib,
  rustPlatform,
  fetchFromSourcehut,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xendmail";
  version = "0.5.0";

  src = fetchFromSourcehut {
    owner = "~whynothugo";
    repo = "xendmail";
    rev = "v${finalAttrs.version}";
    hash = "sha256-oX5+4LDjDXaDIBZCARG9s9pMA9KDlDATB+dkhObMWpM=";
  };

  cargoHash = "sha256-iiq9T0S62/jDgSmg0d5g+wbn2kpWkjKX8EpSsYb9Jic=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A sendmail drop-in replacement designed to be configured by individual system users";
    homepage = "https://git.sr.ht/~whynothugo/xendmail";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      philocalyst
    ];
    mainProgram = "xendmail";
  };
})
