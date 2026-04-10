{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tcping-rs";
  version = "1.2.24";

  src = fetchFromGitHub {
    owner = "lvillis";
    repo = "tcping-rs";
    tag = finalAttrs.version;
    hash = "sha256-gsTZls5guqtDk8x+3q4nFYGwhr+TAV5iE9kiZgbmzCI=";
  };

  cargoHash = "sha256-m/juo6+SPFAxQ7E2JgTkv47kxn4LhwfI4UGSDzHAXMc=";

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
