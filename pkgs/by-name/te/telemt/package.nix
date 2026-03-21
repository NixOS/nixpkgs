{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "telemt";
  version = "3.3.15";

  src = fetchFromGitHub {
    owner = "telemt";
    repo = "telemt";
    tag = version;
    hash = "sha256-pydVq+6ggg11UOJaHu1/YSsTkPwfm0DkD5y7VCmC0E8=";
  };

  cargoHash = "sha256-JfG4lFeQDekw0taNQknEQyw5sMyNZrtcL2qvz5K9u20=";

  meta = {
    mainProgram = "telemt";
    description = "MTProxy for Telegram on Rust + Tokio";
    homepage = "https://github.com/telemt/telemt";
    maintainers = with lib.maintainers; [ r4v3n6101 ];
  };
}
