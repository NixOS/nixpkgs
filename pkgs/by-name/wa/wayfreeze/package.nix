{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libxkbcommon,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wayfreeze";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "Jappie3";
    repo = "wayfreeze";
    tag = finalAttrs.version;
    hash = "sha256-CCtf2P3NxbUHiky/ngrojGbcbALonIIwwFVj61JEG6c=";
  };

  passthru.updateScript = nix-update-script { };

  cargoHash = "sha256-pB314ytkSOxPIv24urNfMbyq3KfYs3MOmivicq267/c=";

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
