{ lib
, rustPlatform
, fetchCrate
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "systemctl-tui";
  version = "0.3.5";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-CONg4amz4WaaZC/RtptzZDxLY8QnYqSnmpbBTILHjos=";
  };

  cargoHash = "sha256-EQ5vAAO52KXt9RhnB+P0cX7mCvXDYSxPfSh+Ak/DN0g=";

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
