{
  lib,
  fetchFromGitHub,
  wrapGAppsHook4,
  rustPlatform,
  cairo,
  glib,
  pango,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "turnon";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "swsnr";
    repo = "turnon";
    rev = "v${version}";
    hash = "sha256-TF6mGETX6cK0ob2LLrjneifwSf+9EEjrv4x7AfWIamQ=";
  };

  cargoHash = "sha256-EpwgvaunShETZqH7v3Dux60pGLeBOtBZhpbDi7Eows4=";

  nativeBuildInputs = [
    cairo
    pango
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
  ];

  #strictDeps = true;

  meta = {
    description = "Turn on devices in your local network";
    homepage = "https://github.com/swsnr/turnon";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ mksafavi ];
    #mainProgram = "";
  };
}
