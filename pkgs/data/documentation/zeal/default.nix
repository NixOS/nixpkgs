{ lib
, stdenv
, fetchFromGitHub
, cmake
, extra-cmake-modules
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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "zealdocs";
    repo = "zeal";
    rev = "v${finalAttrs.version}";
    hash = "sha256-s1FaazHVtWE697BO0hIOgZVowdkq68R9x327ZnJRnlo=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace 'ZEAL_VERSION_SUFFIX "-dev"' 'ZEAL_VERSION_SUFFIX ""'
  '';

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

  meta = {
    description = "A simple offline API documentation browser";
    longDescription = ''
      Zeal is a simple offline API documentation browser inspired by Dash (macOS
      app), available for Linux and Windows.
    '';
    homepage = "https://zealdocs.org/";
    changelog = "https://github.com/zealdocs/zeal/releases";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ skeidel peterhoeg AndersonTorres ];
    inherit (qtbase.meta) platforms;
  };
})
