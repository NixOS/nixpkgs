{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "viddy";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "sachaos";
    repo = "viddy";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RyPG8OAg3i9N2Fq5Hij48wMvfQuTNmJFpatvB3HbXKg=";
  };

  cargoHash = "sha256-P+TtxV2kuHeBHr8GQeJ0VWPkjimfcAtBUFt0z79ML6A=";

  env.VERGEN_BUILD_DATE = "2024-11-28"; # managed via the update script
  env.VERGEN_GIT_DESCRIBE = "Nixpkgs";

  passthru.updateScript.command = [ ./update.sh ];

  meta = {
    description = "Modern `watch` command";
    changelog = "https://github.com/sachaos/viddy/releases";
    homepage = "https://github.com/sachaos/viddy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      j-hui
      phanirithvij
    ];
    mainProgram = "viddy";
  };
})
