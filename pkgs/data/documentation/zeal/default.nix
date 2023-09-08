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
  version = "0.6.1.20230907"; # unstable-date format not suitable for cmake

  src = fetchFromGitHub {
    owner = "zealdocs";
    repo = "zeal";
    rev = "20249153077964d01c7c36b9f4042a40e8c8fbf1";
    hash = "sha256-AyfpMq0R0ummTGvyUHOh/XBUeVfkFwo1VyyLSGoTN8w=";
  };

  # we only need this if we are using a version that hasn't been released. We
  # could also match on the "VERSION x.y.z" bit but then it would have to be
  # updated based on whatever is the latest release, so instead just rewrite the
  # line.
  postPatch = ''
    sed -i CMakeLists.txt \
      -e 's@^project.*@project(Zeal VERSION ${finalAttrs.version})@'
  '' + lib.optionalString (!isQt5) ''
    substituteInPlace src/app/CMakeLists.txt \
      --replace "COMPONENTS Widgets" "COMPONENTS Widgets QmlIntegration"
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
