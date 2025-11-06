{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "tcping-rs";
  version = "1.2.19";

  src = fetchFromGitHub {
    owner = "lvillis";
    repo = "tcping-rs";
    tag = version;
    hash = "sha256-I7rcIemdPGFPBeOoIRft0tq49ikDs49UH5sEobL6fOA=";
  };

  cargoHash = "sha256-k+Hm6dHy6igk1deeVrWrAOdhlz0h/jen6pVNaGvB7Ak=";

  checkFlags = [
    # This test requires external network access
    "--skip=resolve_domain"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TCP Ping (tcping) Utility for Port Reachability";
    homepage = "https://github.com/lvillis/tcping-rs";
    license = lib.licenses.mit;
    mainProgram = "tcping";
    maintainers = with lib.maintainers; [ heitorPB ];
  };
}
