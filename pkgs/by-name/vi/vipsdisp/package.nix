{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch2,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  vips,
  gtk4,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "vipsdisp";
  version = "4.1.3";

  src = fetchFromGitHub {
    owner = "jcupitt";
    repo = "vipsdisp";
    tag = "v${version}";
    hash = "sha256-xTvs52k+OHDaKXu83kKc17lpx0/SmdOI6BaUmBQ/WoY=";
  };

  postPatch = ''
    chmod +x ./meson_post_install.py
    patchShebangs ./meson_post_install.py
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    vips
    gtk4
    python3
  ];

  # No tests implemented.
  doCheck = false;

  meta = {
    homepage = "https://github.com/jcupitt/vipsdisp";
    description = "Tiny image viewer with libvips";
    license = lib.licenses.mit;
    mainProgram = "vipsdisp";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
