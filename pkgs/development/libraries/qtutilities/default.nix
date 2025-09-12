{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  qttools,
  cpp-utilities,
  qtbase,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qtutilities";
  version = "6.18.1";

  src = fetchFromGitHub {
    owner = "Martchus";
    repo = "qtutilities";
    rev = "v${finalAttrs.version}";
    hash = "sha256-GFLNZgY6Q3+4lsFYznbiVhDqU8ALzVRLO02qmyZrnKw=";
  };

  nativeBuildInputs = [
    cmake
    qttools
  ];
  buildInputs = [
    qtbase
    cpp-utilities
  ];

  cmakeFlags = [
    "-DQT_PACKAGE_PREFIX=Qt${lib.versions.major qtbase.version}"
    "-DBUILD_SHARED_LIBS=ON"
  ];

  dontWrapQtApps = true;

  meta = with lib; {
    homepage = "https://github.com/Martchus/qtutilities";
    description = "Common Qt related C++ classes and routines used by @Martchus' applications such as dialogs, widgets and models Topics";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.linux ++ platforms.darwin;
  };
})
