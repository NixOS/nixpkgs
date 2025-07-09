{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tuime";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "nthnd";
    repo = "tuime";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9CGktRXx7IZ0yv/U78SWSifJ6YBIiV8cf5Dq60PPCcQ=";
  };

  cargoHash = "sha256-3jqZ4x2ifvlFI7OcUye+pJ7wdPGcEo1z2PzcWR4xrkU=";

  meta = {
    description = "Tui clock written in rust";
    homepage = "https://github.com/nthnd/tuime";
    changelog = "https://github.com/nthnd/tuime/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "tuime";
  };
})
