{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "tcping-rs";
  version = "1.2.21";

  src = fetchFromGitHub {
    owner = "lvillis";
    repo = "tcping-rs";
    tag = version;
    hash = "sha256-n8eYxq3zFj1337lC7OJ32p9AaMU4HJDWVk0Bkw/STJ0=";
  };

  cargoHash = "sha256-l1VzdBuwNANT9rUEEPuESfOp7/f3tghJrX/SEY9fSeA=";

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
