{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "terminal-toys";
  version = "0-unstable-2025-03-18";

  src = fetchFromGitHub {
    owner = "Seebass22";
    repo = "terminal-toys";
    rev = "04f3510d8b66aae6aac283f0aa96de44fb49dbdd";
    hash = "sha256-MeIFmTwHbJH3IuJD1I+PZgOUbT9NQo+wc+3gWl1GHWs=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-qz0Crz0B3Gn23+g30kTytPlmAe1F+8WsBu61TSHDoQo=";
  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch=main" ]; };

  meta = {
    description = "screensavers for your terminal";
    homepage = "https://github.com/Seebass22/terminal-toys";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "terminal-toys";
  };
}
