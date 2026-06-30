{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wlctl";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "aashish-thapa";
    repo = "wlctl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-omeRIERhax7lmBYcjKm2Vp32yTKvnkOEAgMhRL4/uUY=";
  };

  cargoHash = "sha256-8LTC5fRdwyXZD8EUz2gR0GTaZuldUTYF/WgAfpMsguM=";

  meta = {
    description = "TUI for managing WiFi using NetworkManager (fork of Impala)";
    homepage = "https://github.com/aashish-thapa/wlctl";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      preArcMed821
    ];
    mainProgram = "wlctl";
  };
})
