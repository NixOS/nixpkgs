{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "truehdd";
  version = "0.5.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "truehdd";
    repo = "truehdd";
    tag = finalAttrs.version;
    hash = "sha256-y4x27lmAh0OyIksIqmKG7mTIjzf7TzPlzNaeVrTtB08=";
  };

  cargoHash = "sha256-uVVcPVGgUM/V9CFS/axUSWRt9vOTD/3O2SAENmzVukM=";

  env.VERGEN_GIT_DESCRIBE = finalAttrs.version;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tools for inspecting and decoding Dolby TrueHD bitstreams";
    homepage = "https://github.com/truehdd/truehdd";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      Renna42
    ];
    mainProgram = "truehdd";
    platforms = lib.platforms.all;
  };
})
