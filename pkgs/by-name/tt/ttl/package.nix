{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ttl";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "lance0";
    repo = "ttl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bna3zD1RI2eSYX+IyDxi8IB/gys8PDDRThDdcUfcHR0=";
  };

  cargoHash = "sha256-VLNDcP7LjClYEqew0xDQdevMM0LKJJnUXxh6tBtx6lw=";

  nativeBuildInputs = [
    installShellFiles
    versionCheckHook
  ];

  doInstallCheck = true;

  # opt ouf of default features to deselect the update-check feature
  buildNoDefaultFeatures = true;

  postInstall = ''
    installShellCompletion --cmd ttl \
      --bash <($out/bin/ttl --completions bash) \
      --fish <($out/bin/ttl --completions fish) \
      --zsh <($out/bin/ttl --completions zsh)
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Modern traceroute/mtr-style TUI";
    longDescription = ''
      ttl provides a live traceroute interface that can trace multiple targets,
      detect ECMP paths, run PMTUD, export JSON/CSV reports, and optionally
      enrich hop data with DNS, ASN, geolocation, and PeeringDB information.
    '';
    mainProgram = "ttl";
    homepage = "https://github.com/lance0/ttl";
    changelog = "https://github.com/lance0/ttl/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [
      vincentbernat
      herbetom
    ];
    license = with lib.licenses; [
      asl20
      mit
    ];
    platforms = lib.platforms.all;
  };
})
