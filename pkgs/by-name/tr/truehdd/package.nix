{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "truehdd";
  version = "0.5.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "truehdd";
    repo = "truehdd";
    tag = finalAttrs.version;
    hash = "sha256-paVH6NmPvRHozxDRO4zy+YOjfZQSidlqbd5hZZWwKF8=";
  };

  cargoHash = "sha256-cuzaDTfZ6u6V3FUY913lyB4zy5GsNBam43mrnz3x6MI=";

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
