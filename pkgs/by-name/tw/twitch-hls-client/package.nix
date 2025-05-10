{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "twitch-hls-client";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "2bc4";
    repo = "twitch-hls-client";
    rev = version;
    hash = "sha256-bMND6TFM2lpnUFE6BfrNF88JRImYJy/cGhbSjIWi974=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-TvgRj6OyDcL0/I0o14CD8t2+VYu37kFXMwrS093uA1o=";

  meta = with lib; {
    description = "Minimal CLI client for watching/recording Twitch streams";
    homepage = "https://github.com/2bc4/twitch-hls-client.git";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ lenivaya ];
    mainProgram = "twitch-hls-client";
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    platforms = platforms.all;
  };
}
