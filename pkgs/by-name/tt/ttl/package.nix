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
  version = "0.13.4";

  src = fetchFromGitHub {
    owner = "lance0";
    repo = "ttl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-r1rmyQI4EnLpCYpcz3cNO5XI6uLaBVYTGC8+ttyzUu8=";
  };

  cargoHash = "sha256-fcfgj26cgM7q3byxfVJ2GKRXg4oNd6tj5plEylfJXjQ=";

  nativeBuildInputs = [
    installShellFiles
    versionCheckHook
  ];
  doInstallCheck = true;

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
    maintainers = with lib.maintainers; [ vincentbernat ];
    license = with lib.licenses; [
      asl20
      mit
    ];
    platforms = lib.platforms.all;
  };
})
