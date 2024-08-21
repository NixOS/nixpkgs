{ lib
, rustPlatform
, fetchCrate
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "systemctl-tui";
  version = "0.3.6";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-R7PeExN31vjGJnvRCYZO8DjZWXa17OFZ+lpdxCPIVpE=";
  };

  cargoHash = "sha256-rlKizeWPWZUy23IHII6hrNVLFUR5xSkDQxYrc5WToC0=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
  ];

  meta = with lib; {
    description = "Simple TUI for interacting with systemd services and their logs";
    homepage = "https://crates.io/crates/systemctl-tui";
    license = licenses.mit;
    maintainers = with maintainers; [ siph ];
    mainProgram = "systemctl-tui";
  };
}
