{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "truehdd";
  version = "0.6.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "truehdd";
    repo = "truehdd";
    tag = finalAttrs.version;
    hash = "sha256-MpJmAEBUdPY7+VSbw0VILr2Smcnfu1WmWOB/uOyPOlM=";
  };

  cargoHash = "sha256-BWJUIJcXRjrb2P0EXNdvhVkyq93J3CkYPUYdXgEsYQ4=";

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
