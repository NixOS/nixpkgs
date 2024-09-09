{ lib
, stdenv
, fetchFromGitHub
, cmake
, extra-cmake-modules
, fetchpatch2
, pkg-config
, qtbase
, qtimageformats
, qtwebengine
, qtx11extras
, libarchive
, libXdmcp
, libpthreadstubs
, wrapQtAppsHook
, xcbutilkeysyms
}:

let
  isQt5 = lib.versions.major qtbase.version == "5";

in
stdenv.mkDerivation (finalAttrs: {
  pname = "zeal";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "zealdocs";
    repo = "zeal";
    rev = "v${finalAttrs.version}";
    hash = "sha256-918hWy5be5mHINLbFJPiE29wlL1kRUD4MS3AjML/6fs=";
  };

  patches = [
    # https://github.com/zealdocs/zeal/pull/1644
    (fetchpatch2 {
      name = "fix-qtconcurrent-component.patch";
      url = "https://github.com/zealdocs/zeal/commit/c432a0ac22b59ed44bdcec8819c030d993177883.patch";
      hash = "sha256-DW7rBRMnXm7r+jps1/3RTXA1PpwEUCprW9qrHMRii84=";
    })
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    libXdmcp
    libarchive
    libpthreadstubs
    qtbase
    qtimageformats
    qtwebengine
    xcbutilkeysyms
  ]
  ++ lib.optionals isQt5 [ qtx11extras ];

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
    maintainers = with lib.maintainers; [ peterhoeg AndersonTorres ];
    mainProgram = "zeal";
    inherit (qtbase.meta) platforms;
  };
})
