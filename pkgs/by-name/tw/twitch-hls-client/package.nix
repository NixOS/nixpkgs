{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "twitch-hls-client";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "2bc4";
    repo = "twitch-hls-client";
    rev = version;
    hash = "sha256-UOXz1Gbo1alBnnwOWKlP5ZtaaTYr+Bqxe/+Y5A5B4Eg=";
  };

  cargoHash = "sha256-0bcnObIBsjgzmIrKaypb/iXnloHCRXpJtVXXl2Agk94=";

  meta = {
    description = "Minimal CLI client for watching/recording Twitch streams";
    homepage = "https://github.com/2bc4/twitch-hls-client.git";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ lenivaya ];
    mainProgram = "twitch-hls-client";
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    platforms = lib.platforms.all;
  };
}
