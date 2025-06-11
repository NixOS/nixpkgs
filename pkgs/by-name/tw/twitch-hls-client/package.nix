{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "twitch-hls-client";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "2bc4";
    repo = "twitch-hls-client";
    rev = version;
    hash = "sha256-m6ci7jKmWGsvJZt9CxfU0OCk5GA7I87c5HHdPP+4O94=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-4/a94VFlOvw3TR+LYkq3qghhUudt0S9HF85fy4mYbQM=";

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
