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
  version ? "2.3.0",
  qtx11extras ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libfm-qt";
  inherit version;

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "libfm-qt";
    tag = finalAttrs.version;
    hash =
      {
        "1.4.0" = "sha256-QxPYSA7537K+/dRTxIYyg+Q/kj75rZOdzlUsmSdQcn4=";
        "2.3.0" = "sha256-A0kBwLiPvHIsJWQvg6lwb5lrojU8oDDQYHuC2pTXdPc=";
      }
      ."${finalAttrs.version}";
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
  ++ (lib.optionals (lib.versionAtLeast "2.0.0" finalAttrs.version) [ qtx11extras ]);

  passthru.updateScript = gitUpdater { };

  postPatch = lib.optionals (version == "1.4.0") ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.1.0 FATAL_ERROR)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = {
    homepage = "https://github.com/lxqt/libfm-qt";
    description = "Core library of PCManFM-Qt (Qt binding for libfm)";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
    teams = [ lib.teams.lxqt ];
  };
})
