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
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "swsnr";
    repo = "turnon";
    rev = "v${version}";
    hash = "sha256-727v1jQBBueLHvk0DphMHnrgJe46gap3hp0ygUYezJ0=";
  };

  cargoHash = "sha256-mywGCIjsoShRPRNMkTmVh7597QdvBSIsI/HucYv3CzY=";

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
