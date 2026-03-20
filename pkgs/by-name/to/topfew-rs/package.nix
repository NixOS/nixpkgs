{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "topfew-rs";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "djc";
    repo = "topfew-rs";
    tag = finalAttrs.version;
    hash = "sha256-VlSLPcKw3LYGnmKk5YOkcGIizw1tqtKF2BykY+1MtvY=";
  };

  cargoHash = "sha256-NAM/s3m+ZqgHoX6GESgJOxr88sy4+JieWB8u8aKbW7Y=";

  meta = {
    description = "Rust implementation of Tim Bray's topfew tool";
    homepage = "https://github.com/djc/topfew-rs";
    maintainers = with lib.maintainers; [ liberodark ];
    license = lib.licenses.gpl3Only;
    mainProgram = "tf";
  };
})
