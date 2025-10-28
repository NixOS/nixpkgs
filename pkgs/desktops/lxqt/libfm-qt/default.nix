{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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
        "2.2.0" = "sha256-xLXHwrcMJ8PObZ2qWVZTf9FREcjUi5qtcCJgNHj391Q=";
      }
      ."${finalAttrs.version}";
  };

  patches = lib.optionals (finalAttrs.version == "2.2.0") [
    # fix build against Qt >= 6.10 (https://github.com/lxqt/libfm-qt/pull/1060)
    # TODO: drop when upgrading beyond version 2.2.0
    (fetchpatch {
      name = "cmake-fix-build-with-Qt-6.10.patch";
      url = "https://github.com/lxqt/libfm-qt/commit/3bcbae5831f5ce3d2f06dc370f0c2ad0026ae82a.patch";
      hash = "sha256-nTuPXlkP7AzC8R4OHfQx6/kxPsDjaw7tGzQGyiYqQSQ=";
    })
  ];

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
