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
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "swsnr";
    repo = "turnon";
    rev = "v${version}";
    hash = "sha256-HCeK0aOGxeiZD7Am+kUf3z4rT7JENQxyrAufBStrSms=";
  };

  cargoHash = "sha256-43hv+ZCpgXK6GGMDG0hXza7g4jvRNmr57MTgkvTOvVQ=";

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
