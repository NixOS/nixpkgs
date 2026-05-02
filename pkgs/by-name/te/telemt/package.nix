{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "telemt";
  version = "3.4.5";

  src = fetchFromGitHub {
    owner = "telemt";
    repo = "telemt";
    tag = version;
    hash = "sha256-zOdVnW7RTPAbR6fpzDqPpwhOWjxknmg8TzGXmBCbWjg=";
  };

  cargoHash = "sha256-/7Xd/6NEu6QqFdVUz4M+iz9+7K5lEDguyaprAKh86wo=";

  meta = {
    mainProgram = "telemt";
    description = "MTProxy for Telegram on Rust + Tokio";
    homepage = "https://github.com/telemt/telemt";
    maintainers = with lib.maintainers; [ r4v3n6101 ];
  };
}
