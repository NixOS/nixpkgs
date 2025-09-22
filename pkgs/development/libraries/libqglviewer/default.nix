{
  lib,
  stdenv,
  fetchFromGitHub,
  qmake,
  qtbase,
  libGLU,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libqglviewer";
  version = "2.9.1";

  src = fetchFromGitHub {
    owner = "GillesDebunne";
    repo = "libQGLViewer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-T8KAcw3cXbp0FZm53OjlQBnUvLRFdoj80dIQzQY0/yw=";
  };

  nativeBuildInputs = [ qmake ];
  buildInputs = [
    qtbase
    libGLU
  ];

  dontWrapQtApps = true;

  # Fix build on darwin, and install dylib instead of framework
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace QGLViewer/QGLViewer.pro \
      --replace-fail \
        "LIB_DIR_ = /Library/Frameworks" \
        "LIB_DIR_ = \$\$""{PREFIX_}/lib" \
      --replace-fail \
        "!staticlib: CONFIG *= lib_bundle" \
        ""
  '';

  preConfigure = ''
    cd QGLViewer
  '';

  meta = {
    description = "C++ library based on Qt that eases the creation of OpenGL 3D viewers";
    homepage = "https://github.com/GillesDebunne/libQGLViewer";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.all;
  };
})
