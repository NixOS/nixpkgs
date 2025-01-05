{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  pkg-config,
  httplib,
  qtbase,
  qtimageformats,
  qtwebengine,
  qtx11extras,
  libarchive,
  libXdmcp,
  libpthreadstubs,
  wrapQtAppsHook,
  xcbutilkeysyms,
}:

let
  isQt5 = lib.versions.major qtbase.version == "5";

in
stdenv.mkDerivation (finalAttrs: {
  pname = "zeal";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "zealdocs";
    repo = "zeal";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9tlo7+namWNWrWVQNqaOvtK4NQIdb0p8qvFrrbUamOo=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    httplib
    libXdmcp
    libarchive
    libpthreadstubs
    qtbase
    qtimageformats
    qtwebengine
    xcbutilkeysyms
  ] ++ lib.optionals isQt5 [ qtx11extras ];

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
    changelog = "https://github.com/zealdocs/zeal/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      peterhoeg
      AndersonTorres
    ];
    mainProgram = "zeal";
    inherit (qtbase.meta) platforms;
  };
})
