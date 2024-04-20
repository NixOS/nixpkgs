{ lib
, rustPlatform
, fetchCrate
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "systemctl-tui";
  version = "0.3.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-oFXLxWS2G+CkG0yuJLkA34SqoGGcXU/eZmFMRYw+Gzo=";
  };

  cargoHash = "sha256-MKxeRQupgAxA2ui8qSK8BvhxqqgjJarD8pY9wmk8MvA=";

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
