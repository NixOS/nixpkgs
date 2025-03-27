{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "twitch-hls-client";
  version = "1.3.13";

  src = fetchFromGitHub {
    owner = "2bc4";
    repo = "twitch-hls-client";
    rev = version;
    hash = "sha256-H446qXFwRGippLMZemkW8sVhTV3YGpKmAvD8QBamAlo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-sqhB2Lj3RK1OyXy87Be9aOkfcksqz+5VfRTlKuswerU=";

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
