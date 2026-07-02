{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "twitch-hls-client";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "2bc4";
    repo = "twitch-hls-client";
    rev = finalAttrs.version;
    hash = "sha256-AoefKtAiM8Xi1DoPDH2E623QSC668qrQLOLpdtFxuAs=";
  };

  cargoHash = "sha256-j4y3os2l0PmmE7T3RFJMsnFfulN9uR6nMGaPZCBc7dE=";

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
