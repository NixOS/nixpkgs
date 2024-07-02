{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  boost,
  cmake,
  doxygen,
  jrl-cmakemodules,
  openscenegraph,
  osgqt,
  pkg-config,
  python3Packages,
  qgv,
  libsForQt5,
  python-qt,
}:

buildPythonPackage rec {
  pname = "gepetto-viewer";
  version = "5.1.0";
  pyproject = false; # CMake

  src = fetchFromGitHub {
    owner = "gepetto";
    repo = "gepetto-viewer";
    rev = "v${version}";
    hash = "sha256-A2J3HidG+OHJO8LpLiOEvORxDtViTdeVD85AmKkkOg8=";
  };

  cmakeFlags = [ "-DBUILD_PY_QCUSTOM_PLOT=ON" ];

  outputs = [
    "out"
    "doc"
  ];

  buildInputs = [
    boost
    python-qt
    libsForQt5.qtbase
    osgqt
    python3Packages.boost
    python3Packages.python
  ];

  nativeBuildInputs = [
    cmake
    doxygen
    libsForQt5.wrapQtAppsHook
    pkg-config
  ];

  propagatedBuildInputs = [
    jrl-cmakemodules
    openscenegraph
    osgqt
    qgv
  ];

  doCheck = true;

  # display a black screen on wayland, so force XWayland for now.
  # Might be fixed when upstream will be ready for Qt6.
  qtWrapperArgs = [ "--set QT_QPA_PLATFORM xcb" ];

  meta = {
    homepage = "https://github.com/gepetto/gepetto-viewer";
    license = lib.licenses.lgpl3Only;
    maintainers = [ lib.maintainers.nim65s ];
    mainProgram = "gepetto-gui";
  };
}
