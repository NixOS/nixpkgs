{
  lib,
  rustPlatform,
  fetchCrate,
  stdenv,
  darwin,
  nix-update-script,
  testers,
  systemctl-tui,
}:

rustPlatform.buildRustPackage rec {
  pname = "systemctl-tui";
  version = "0.3.8";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-i2PKSvjsrITLp3a3EgfFF3IR464mkkDnh8ITLO+o0hU=";
  };

  cargoHash = "sha256-6cFK1wMO5VICfi3tN140XH9inQOkkSfHVogKhTHtQb8=";

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.AppKit ];

  passthru = {
    updateScript = nix-update-script;
    tests.version = testers.testVersion { package = systemctl-tui; };
  };

  meta = {
    description = "Simple TUI for interacting with systemd services and their logs";
    homepage = "https://crates.io/crates/systemctl-tui";
    changelog = "https://github.com/rgwood/systemctl-tui/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ siph ];
    mainProgram = "systemctl-tui";
  };
}
