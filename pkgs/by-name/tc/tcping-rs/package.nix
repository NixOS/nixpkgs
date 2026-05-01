{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tcping-rs";
  version = "1.2.26";

  src = fetchFromGitHub {
    owner = "lvillis";
    repo = "tcping-rs";
    tag = finalAttrs.version;
    hash = "sha256-qcvoV57t36c230p7KRec9CBIb+F+dVeGU4EVs0DrREM=";
  };

  cargoHash = "sha256-Y+Hv4oWHTzC/8DQ6/wQ3QLtDy/rqQs+89x312cYOpKY=";

  checkFlags = [
    # This test requires external network access
    "--skip=resolve_domain"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TCP Ping (tcping) Utility for Port Reachability";
    homepage = "https://github.com/lvillis/tcping-rs";
    changelog = "https://github.com/lvillis/tcping-rs/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "tcping";
    maintainers = with lib.maintainers; [ heitorPB ];
  };
})
