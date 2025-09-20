{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libXdmcp,
  libexif,
  libfm,
  libpthreadstubs,
  libxcb,
  lxqt-build-tools,
  lxqt-menu-data,
  menu-cache,
  pkg-config,
  qttools,
  wrapQtAppsHook,
  gitUpdater,
  version ? "2.2.0",
  qtx11extras ? null,
}:

stdenv.mkDerivation rec {
  pname = "libfm-qt";
  inherit version;

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "libfm-qt";
    rev = version;
    hash =
      {
        "1.4.0" = "sha256-QxPYSA7537K+/dRTxIYyg+Q/kj75rZOdzlUsmSdQcn4=";
        "2.2.0" = "sha256-xLXHwrcMJ8PObZ2qWVZTf9FREcjUi5qtcCJgNHj391Q=";
      }
      ."${version}";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    lxqt-build-tools
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    libXdmcp
    libexif
    libfm
    libpthreadstubs
    libxcb
    lxqt-menu-data
    menu-cache
  ]
  ++ (lib.optionals (lib.versionAtLeast "2.0.0" version) [ qtx11extras ]);

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://github.com/lxqt/libfm-qt";
    description = "Core library of PCManFM-Qt (Qt binding for libfm)";
    license = lib.licenses.lgpl21Plus;
    platforms = with lib.platforms; unix;
    teams = [ lib.teams.lxqt ];
  };
}
