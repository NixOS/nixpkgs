{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "ttypr";
  version = "0-unstable-2025-07-29";

  src = fetchFromGitHub {
    owner = "hotellogical05";
    repo = "ttypr";
    rev = "9b9c7640c6e7378699e9fccc0a13d9047d4f45a5";
    hash = "sha256-M74COe/+0+VSpL8dA+Gj/HxQoP8WW8SZ9rdKneK5BWE=";
  };

  cargoHash = "sha256-p36QPk8x1m5iUCa2PxPH5Fk+fwTFxaCJvHnKJadTw9U=";

  meta = {
    description = "Terminal typing practice";
    longDescription = ''
      ttypr is a simple, lightweight typing practice application that
      runs in your terminal, built with Rust and Ratatui.
    '';
    homepage = "https://github.com/hotellogical05/ttypr";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "ttypr";
  };
}
