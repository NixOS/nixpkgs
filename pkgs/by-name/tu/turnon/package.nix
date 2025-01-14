{
  lib,
  fetchFromGitHub,
  rustPlatform,
  cairo,
  pango,
  pkg-config,
  libadwaita,
  blueprint-compiler,
  wrapGAppsHook4,
}:

rustPlatform.buildRustPackage rec {
  pname = "turnon";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "swsnr";
    repo = "turnon";
    rev = "v${version}";
    hash = "sha256-Azl89dj07GrYQLuZFrR3RDCX7gPFtAsxTSbY2bLrt28=";
  };

  cargoHash = "sha256-W26/acaAvFg2KnRCwZZsh1z6Y/aRxtDaenG/b+YmsbI=";

  nativeBuildInputs = [
    cairo
    pango
    pkg-config
    blueprint-compiler
    wrapGAppsHook4
  ];

  buildInputs = [
    libadwaita
  ];

  strictDeps = true;

  preBuild = ''
    blueprint-compiler format resources/**/*.blp
  '';

  meta = {
    description = "Turn on devices in your local network";
    homepage = "https://github.com/swsnr/turnon";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ mksafavi ];
    mainProgram = "turnon";
    platforms = lib.platforms.linux;
  };
}
