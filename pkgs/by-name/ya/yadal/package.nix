{
  lib,
  rustPlatform,
  fetchFromCodeberg,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "yadal";
  version = "0.4.0";

  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "tomkoid";
    repo = "yadal";
    tag = finalAttrs.version;
    hash = "sha256-MOp1qlg/rittAcD/0JMvE1o/U+J6o66JRR8uVbdpw5Y=";
  };

  cargoHash = "sha256-J5huE4z8W9C2tVeir8VB7YmOROmr0umqZkbZSOo1iJs=";

  meta = {
    description = "Yet another TIDAL Hi-Res audio downloader for the CLI";
    homepage = "https://codeberg.org/tomkoid/yadal";
    license = lib.licenses.gpl3Only;
    changelog = "https://codeberg.org/tomkoid/yadal/releases/tag/${finalAttrs.version}";
    maintainers = with lib.maintainers; [ tomkoid ];
    mainProgram = "yadal";
  };
})
