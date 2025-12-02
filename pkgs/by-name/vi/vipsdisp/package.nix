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
  version = "4.1.2";

  src = fetchFromGitHub {
    owner = "jcupitt";
    repo = "vipsdisp";
    tag = "v${version}";
    hash = "sha256-9L8l/afD6phq8T3ReYqQQgD1CztW5gw0MME23Ut/lEE=";
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
    maintainers = with lib.maintainers; [ foo-dogsquared ];
    platforms = lib.platforms.unix;
  };
}
