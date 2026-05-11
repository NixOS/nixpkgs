{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libxkbcommon,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wayfreeze";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "Jappie3";
    repo = "wayfreeze";
    tag = finalAttrs.version;
    hash = "sha256-jz77zWCUUcXiLdCQpta1b1dlEZaahkhYfhnHUa/Zk2A=";
  };

  passthru.updateScript = nix-update-script { };

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
})
