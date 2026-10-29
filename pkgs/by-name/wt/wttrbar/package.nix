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
  version = "0.14.5";

  src = fetchFromGitHub {
    owner = "bjesus";
    repo = "wttrbar";
    tag = finalAttrs.version;
    hash = "sha256-ztCidqh6DPtGBM8rfEmPi5AXqo4iF8n9lvyBGMxuh1o=";
  };

  cargoHash = "sha256-oumahPzbX8EjuQt1ke7yc1KAGayjsRcucsSm9uT6gOs=";

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
