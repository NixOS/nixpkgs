{ lib
, stdenv
, fetchFromGitHub
, cmake
, extra-cmake-modules
, pkg-config
, qtbase
, qtimageformats
, qtwebengine
<<<<<<< HEAD
, qtx11extras
=======
, qtx11extras ? null # qt5 only
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, libarchive
, libXdmcp
, libpthreadstubs
, wrapQtAppsHook
, xcbutilkeysyms
}:

let
  isQt5 = lib.versions.major qtbase.version == "5";
<<<<<<< HEAD
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zeal";
  version = "0.6.1.20230907"; # unstable-date format not suitable for cmake
=======

in
stdenv.mkDerivation rec {
  pname = "zeal";
  version = "0.6.1.20230320";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "zealdocs";
    repo = "zeal";
<<<<<<< HEAD
    rev = "20249153077964d01c7c36b9f4042a40e8c8fbf1";
    hash = "sha256-AyfpMq0R0ummTGvyUHOh/XBUeVfkFwo1VyyLSGoTN8w=";
=======
    rev = "a617ae5e06b95cec99bae058650e55b98613916d";
    hash = "sha256-WL2uqA0sZ5Q3lZIA9vkLVyfec/jBkfGcWb6XQ7AuM94=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # we only need this if we are using a version that hasn't been released. We
  # could also match on the "VERSION x.y.z" bit but then it would have to be
  # updated based on whatever is the latest release, so instead just rewrite the
  # line.
  postPatch = ''
    sed -i CMakeLists.txt \
<<<<<<< HEAD
      -e 's@^project.*@project(Zeal VERSION ${finalAttrs.version})@'
=======
      -e 's@^project.*@project(Zeal VERSION ${version})@'
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '' + lib.optionalString (!isQt5) ''
    substituteInPlace src/app/CMakeLists.txt \
      --replace "COMPONENTS Widgets" "COMPONENTS Widgets QmlIntegration"
  '';

<<<<<<< HEAD
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
=======
  nativeBuildInputs = [ cmake extra-cmake-modules pkg-config wrapQtAppsHook ];

  buildInputs = [
    qtbase
    qtimageformats
    qtwebengine
    libarchive
    libXdmcp
    libpthreadstubs
    xcbutilkeysyms
  ] ++ lib.optionals isQt5 [ qtx11extras ];

  meta = with lib; {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "A simple offline API documentation browser";
    longDescription = ''
      Zeal is a simple offline API documentation browser inspired by Dash (macOS
      app), available for Linux and Windows.
    '';
    homepage = "https://zealdocs.org/";
<<<<<<< HEAD
    changelog = "https://github.com/zealdocs/zeal/releases";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ skeidel peterhoeg AndersonTorres ];
    inherit (qtbase.meta) platforms;
  };
})
=======
    license = licenses.gpl3;
    maintainers = with maintainers; [ skeidel peterhoeg ];
    platforms = platforms.linux;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
