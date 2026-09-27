{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wttrbar";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "bjesus";
    repo = "wttrbar";
    tag = finalAttrs.version;
    hash = "sha256-/tavOutTrBVsR9utbTfe3Np4p8WOBppUPXgBd0/vMEk=";
  };

  cargoHash = "sha256-RqRG2tVU2ynwDx0a8riLKf3E4sCIRO70pHDEAvSDiAg=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple but detailed weather indicator for Waybar using wttr.in";
    homepage = "https://github.com/bjesus/wttrbar";
    changelog = "https://github.com/bjesus/wttrbar/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
    mainProgram = "wttrbar";
  };
})
