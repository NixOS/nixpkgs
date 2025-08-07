{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "tcping-rs";
  version = "1.2.18";

  src = fetchFromGitHub {
    owner = "lvillis";
    repo = "tcping-rs";
    tag = version;
    hash = "sha256-G9LZ9XlIl/JYji/GgznQnIbnV83qi9kZqCkaZJ0kENI=";
  };

  cargoHash = "sha256-INbXvNfn3vmXzZgaDUwl1wgbQ2wVQcCP0ZV2dpZedQY=";

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
