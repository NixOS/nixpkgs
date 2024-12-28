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
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "swsnr";
    repo = "turnon";
    rev = "v${version}";
    hash = "sha256-e9xrBtLAe/OAiDMn87IuzS/6NT8s4ZRHLAI/KF42ZdU=";
  };

  cargoHash = "sha256-DlEoJ5YJe679RFRfk/Bs217KrOSxSgqDJa+xpdJaTVs=";

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
