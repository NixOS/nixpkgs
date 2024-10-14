{ lib, stdenv, fetchFromGitHub, qmake, qtbase, libGLU, AGL }:

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
  buildInputs = [ qtbase libGLU ]
    ++ lib.optional stdenv.hostPlatform.isDarwin AGL;

  dontWrapQtApps = true;

  postPatch = ''
    cd QGLViewer
  '';

  meta = {
    description = "C++ library based on Qt that eases the creation of OpenGL 3D viewers";
    homepage = "https://github.com/GillesDebunne/libQGLViewer";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.all;
  };
})
