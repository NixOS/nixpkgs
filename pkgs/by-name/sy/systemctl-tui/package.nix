{ lib
, rustPlatform
, fetchCrate
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "systemctl-tui";
  version = "0.2.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-q/LzehMspiqxQOgALh1smhmL1803xr4GzIw9t+jE6NM=";
  };

  cargoHash = "sha256-GNuWag8Y1aSkBMzXcHpwfVU80zmhusLIOrKtZSe/jI0=";

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
