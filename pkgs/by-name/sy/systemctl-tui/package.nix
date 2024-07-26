{ lib
, rustPlatform
, fetchCrate
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "systemctl-tui";
  version = "0.2.4";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-SZmOCx9S5WWz9fSlicvT/glZKj5AsFDRnxmHbGxM9Ms=";
  };

  cargoHash = "sha256-zUc6RchoGtJB+gnJNwNu93to775fdM5JDJ4qYwRdJn0=";

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
