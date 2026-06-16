{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "twitch-hls-client";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "2bc4";
    repo = "twitch-hls-client";
    rev = finalAttrs.version;
    hash = "sha256-GtnAx94bQGb5rokXsep815+OeazBCfoDRkvTGQKDC4c=";
  };

  cargoHash = "sha256-2z1ezQjOrji6wh7Rg8RYeRJxAi1uSwTjnQ/xOBiCYoY=";

  meta = {
    description = "Minimal CLI client for watching/recording Twitch streams";
    homepage = "https://github.com/2bc4/twitch-hls-client.git";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ lenivaya ];
    mainProgram = "twitch-hls-client";
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    platforms = lib.platforms.all;
  };
})
