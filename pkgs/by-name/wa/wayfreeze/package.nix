{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libxkbcommon,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "wayfreeze";
  version = "0.2.0-unstable-2026-01-17";

  src = fetchFromGitHub {
    owner = "Jappie3";
    repo = "wayfreeze";
    rev = "8f813abc5082e1375326ca0f888834f79f872006";
    hash = "sha256-jz77zWCUUcXiLdCQpta1b1dlEZaahkhYfhnHUa/Zk2A=";
  };

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  cargoHash = "sha256-cofOfaCDKjVpXJHqXiqz2PSIiscYIzCQI2tm5EdWRvE=";

  buildInputs = [
    libxkbcommon
  ];

  meta = {
    description = "Tool to freeze the screen of a Wayland compositor";
    homepage = "https://github.com/Jappie3/wayfreeze";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      purrpurrn
      jappie3 # upstream dev
    ];
    mainProgram = "wayfreeze";
    platforms = lib.platforms.linux;
  };
}
