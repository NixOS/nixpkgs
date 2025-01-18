{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
  ...
}:

rustPlatform.buildRustPackage {
  pname = "twitch-hls-client";
  version = "unstable-2024-10-16";

  src = fetchFromGitHub {
    owner = "2bc4";
    repo = "twitch-hls-client";
    rev = "4d1b6fe71d18f7c7dbceea04a99c98db16cd0d0b";
    hash = "sha256-ja2pFmJNFfNMaNlkgvfxCFYyuVup6CgIEhnbzyk/kro=";
  };

  cargoHash = "sha256-XL/LSEhWZB7p9wgisKcGWDknEvNNFje5WLQazS1730o=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

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
