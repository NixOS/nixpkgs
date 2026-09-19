{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  sqlite,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "threatdeck";
  version = "0.1.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gripebomb";
    repo = "threatdeck";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WJ4Mk3E8BAn/tRU5FJdlQxOTgRX+dSBvtBZSQ14NVJc=";
  };

  cargoHash = "sha256-C5EwT+0cXh75sGhPiwU5EdmBWq8XneGUJIGGRxRJkIs=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    sqlite
  ];

  meta = {
    description = "Terminal-based threat intelligence monitoring and alerting platform";
    homepage = "https://github.com/gripebomb/threatdeck";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gwg313 ];
    mainProgram = "ThreatDeck";
  };
})
