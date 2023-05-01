{ lib
, stdenv
, fetchFromGitHub
, cmake
, extra-cmake-modules
, pkg-config
, qtbase
, qtimageformats
, qtwebengine
, qtx11extras ? null # qt5 only
, libarchive
, libXdmcp
, libpthreadstubs
, wrapQtAppsHook
, xcbutilkeysyms
}:

let
  isQt5 = lib.versions.major qtbase.version == "5";

in
stdenv.mkDerivation rec {
  pname = "zeal";
  version = "0.6.1.20230320";

  src = fetchFromGitHub {
    owner = "zealdocs";
    repo = "zeal";
    rev = "a617ae5e06b95cec99bae058650e55b98613916d";
    hash = "sha256-WL2uqA0sZ5Q3lZIA9vkLVyfec/jBkfGcWb6XQ7AuM94=";
  };

  # we only need this if we are using a version that hasn't been released. We
  # could also match on the "VERSION x.y.z" bit but then it would have to be
  # updated based on whatever is the latest release, so instead just rewrite the
  # line.
  postPatch = ''
    sed -i CMakeLists.txt \
      -e 's@^project.*@project(Zeal VERSION ${version})@'
  '' + lib.optionalString (!isQt5) ''
    substituteInPlace src/app/CMakeLists.txt \
      --replace "COMPONENTS Widgets" "COMPONENTS Widgets QmlIntegration"
  '';

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
    description = "A simple offline API documentation browser";
    longDescription = ''
      Zeal is a simple offline API documentation browser inspired by Dash (macOS
      app), available for Linux and Windows.
    '';
    homepage = "https://zealdocs.org/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ skeidel peterhoeg ];
    platforms = platforms.linux;
  };
}
