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
in stdenv.mkDerivation rec {
  pname = "zeal";
  version = "0.6.20221022";

  src = fetchFromGitHub {
    owner = "zealdocs";
    repo = "zeal";
    rev = "7ea03e4bb9754020e902a2989f56f4bc42b85c82";
    sha256 = "sha256-BozRLlws56i9P7Qtc5qPZWgJR5yhYqnLQsEdsymt5us=";
  };

  # we only need this if we are using a version that hasn't been released. We
  # could also match on the "VERSION x.y.z" bit but then it would have to be
  # updated based on whatever is the latest release, so instead just rewrite the
  # line.
  postPatch = ''
    sed -i CMakeLists.txt \
      -e 's@^project.*@project(Zeal VERSION ${version})@'
  '';

  nativeBuildInputs = [ cmake extra-cmake-modules pkg-config wrapQtAppsHook ];

  buildInputs =
    [
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
