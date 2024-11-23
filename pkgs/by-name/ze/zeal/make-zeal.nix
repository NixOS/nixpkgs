{
  pname,
  version,
  hash,
  flavor,
}:

{
  lib,
  cmake,
  extra-cmake-modules,
  fetchFromGitHub,
  httplib,
  libXdmcp,
  libarchive,
  libpthreadstubs,
  pkg-config,
  qt5,
  qt6,
  stdenv,
  xcbutilkeysyms,
}:

let
  qt =
    if flavor == "qt5" then
      qt5
    else if flavor == "qt6" then
      qt6
    else
      throw "unknown flavor ${flavor}";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "zealdocs";
    repo = "zeal";
    rev = "v${version}";
    inherit hash;
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
    qt.wrapQtAppsHook
  ];

  buildInputs = [
    httplib
    libXdmcp
    libarchive
    libpthreadstubs
    qt.qtbase
    qt.qtimageformats
    qt.qtwebengine
    xcbutilkeysyms
  ] ++ lib.optionals (flavor == "qt5") [ qt.qtx11extras ];

  cmakeFlags = [
    (lib.cmakeBool "ZEAL_RELEASE_BUILD" true)
  ];

  meta = {
    description = "Simple offline API documentation browser";
    longDescription = ''
      Zeal is a simple offline API documentation browser inspired by Dash (macOS
      app), available for Linux and Windows.
    '';
    homepage = "https://zealdocs.org/";
    changelog = "https://github.com/zealdocs/zeal/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      peterhoeg
      AndersonTorres
    ];
    mainProgram = "zeal";
    inherit (qt.qtbase.meta) platforms;
  };
}
