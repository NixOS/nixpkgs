{ lib
, rustPlatform
, fetchCrate
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "systemctl-tui";
  version = "0.3.4";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-yEBh8A0mWXVBkbemPEhvSNgsP+YF/WiLYKMkOPCa6e4=";
  };

  cargoHash = "sha256-IaDAQ9EHkcwwI2z0c8YNIgbjs2zwMblHbCKF0E92+V8=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
  ];

  meta = with lib; {
    description = "A simple TUI for interacting with systemd services and their logs";
    homepage = "https://crates.io/crates/systemctl-tui";
    license = licenses.mit;
    maintainers = with maintainers; [ siph ];
    mainProgram = "systemctl-tui";
  };
}
