{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "truehdd";
  version = "0.4.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "truehdd";
    repo = "truehdd";
    tag = finalAttrs.version;
    hash = "sha256-PhJWtiYtELNkpnhI9e6tv3zFsSJnIYhu2eSy7RyReUE=";
  };

  cargoHash = "sha256-UvHdFtdkQPySEpCZ31n25jfvCsf7ETA7SVSR+/WfEM8=";

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
