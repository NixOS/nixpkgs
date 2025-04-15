{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "twitch-hls-client";
  version = "1.3.14";

  src = fetchFromGitHub {
    owner = "2bc4";
    repo = "twitch-hls-client";
    rev = version;
    hash = "sha256-g7pnTu6NHvtge7vUyG1Cms6hv4ozPgawMUKYGU7VRak=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Suq+j4/lmkEMg6VlLT8UcPcVjDyBLyjUaqPXdqDo3dU=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
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
