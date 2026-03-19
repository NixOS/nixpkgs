{
  lib,
  fetchFromGitHub,
  rustPlatform,
  sqlite,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ytsub";
  version = "0.9.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sarowish";
    repo = "ytsub";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6qPNSkUAj11Rut/Wx724UsFdRLwZh2Z+ZC7837CeNeQ=";
  };

  cargoHash = "sha256-RHOG43LTI3K0VzEpGsdSKheL1fjIZ1TyB6FCgoInUm8=";

  buildInputs = [ sqlite ];

  meta = {
    description = "Subscriptions only TUI Youtube client";
    homepage = "https://github.com/sarowish/ytsub";
    changelog = "https://github.com/sarowish/ytsub/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sarowish ];
    mainProgram = "ytsub";
  };
})
