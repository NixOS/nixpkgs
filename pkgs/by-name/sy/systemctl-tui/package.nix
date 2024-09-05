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
  version = "0.3.7";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-i0yCVXip1RcvKqxidflgW4wJFxAmUPRO04CeETzUgms=";
  };

  cargoHash = "sha256-4gY9pQO2ljbyviaL20ikEqwdAHS4bqpzE6YyaBW/b7c=";

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
