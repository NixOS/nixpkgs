{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "telemt";
  version = "3.4.11";

  src = fetchFromGitHub {
    owner = "telemt";
    repo = "telemt";
    tag = version;
    hash = "sha256-jBspeSj8aRbHngK8bviVt/i1UiYUPRHSd8+7dnmJOQY=";
  };

  cargoHash = "sha256-x5/SLSlYeGx40oXj/I/5zvyTNgSBwKsA33OwVIq9LGw=";

  meta = {
    mainProgram = "telemt";
    description = "MTProxy for Telegram on Rust + Tokio";
    homepage = "https://github.com/telemt/telemt";
    maintainers = with lib.maintainers; [ r4v3n6101 ];
  };
}
