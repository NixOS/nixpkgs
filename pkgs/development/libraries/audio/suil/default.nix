{
  stdenv,
  lib,
  fetchFromGitLab,

  # build time
  pkg-config,
  meson,
  ninja,
  sphinxygen,
  doxygen,
  sphinx,
  python3Packages,

  # runtime
  lv2,

  # options
  withGtk2 ? false,
  gtk2,
  withGtk3 ? true,
  gtk3,
  withQt5 ? true,
  qt5,
  withX11 ? !stdenv.hostPlatform.isDarwin,
}:

let
  inherit (lib) mesonEnable;
in

stdenv.mkDerivation rec {
  pname = "suil";
  version = "0.10.20";

  src = fetchFromGitLab {
    owner = "lv2";
    repo = "suil";
    rev = "v${version}";
    hash = "sha256-rP8tq+zmHrAZeuNttakPPfraFXNvnwqbhtt+LtTNV/k=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    sphinxygen
    doxygen
    sphinx
    python3Packages.sphinx-lv2-theme
  ];

  mesonFlags = [
    (mesonEnable "gtk2" withGtk2)
    (mesonEnable "gtk3" withGtk3)
    (mesonEnable "qt5" withQt5)
    (mesonEnable "x11" withX11)
  ];

  buildInputs =
    [ lv2 ]
    ++ lib.optionals withGtk2 [ gtk2 ]
    ++ lib.optionals withGtk3 [ gtk3 ]
    ++ lib.optionals withQt5 (
      with qt5;
      [
        qtbase
        qttools
      ]
      ++ lib.optionals withX11 [ qtx11extras ]
    );

  dontWrapQtApps = true;

  strictDeps = true;

  meta = with lib; {
    homepage = "http://drobilla.net/software/suil";
    description = "Lightweight C library for loading and wrapping LV2 plugin UIs";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
