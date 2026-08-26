{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "truehdd";
  version = "0.6.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "truehdd";
    repo = "truehdd";
    tag = finalAttrs.version;
    hash = "sha256-lht6vlvAKo2EwtRNkGbuf+/OYvE/+auadUEIXg6Vo/w=";
  };

  cargoHash = "sha256-06cd/xALui85Cp85VAihxGGRAO6K49Y95HeW3l2w7Po=";

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
