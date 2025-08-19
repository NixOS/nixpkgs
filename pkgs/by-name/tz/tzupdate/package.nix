{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "tzupdate";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "cdown";
    repo = "tzupdate";
    tag = version;
    hash = "sha256-eod4yFzX7pATNQmG7jU+r9mnC9nprJ55ufMXpKjw/YI=";
  };

  cargoHash = "sha256-v6Om9lnFKMuLFdxhU3qmyZLV/f+C3vCMp9luU0jZBEQ=";

  meta = {
    description = "Set the system timezone based on IP geolocation";
    homepage = "https://github.com/cdown/tzupdate";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      camillemndn
      doronbehar
    ];
    platforms = lib.platforms.linux;
    mainProgram = "tzupdate";
  };
}
