{ lib, stdenv, fetchurl, qmake, qtbase, libGLU, AGL }:

stdenv.mkDerivation (finalAttrs: {
  pname = "libqglviewer";
  version = "2.9.1";

  src = fetchurl {
    url = "http://www.libqglviewer.com/src/libQGLViewer-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-J4+DKgstPvvg1pUhGd+8YFh5C3oPGHaQmDfLZzzkP/M=";
  };

  # Fix build on darwin, and install dylib instead of framework
  prePatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace QGLViewer/QGLViewer.pro \
      --replace-fail \
        "LIB_DIR_ = /Library/Frameworks" \
        "LIB_DIR_ = \$\$""{PREFIX_}/lib" \
      --replace-fail \
        "!staticlib: CONFIG *= lib_bundle" \
        ""
  '';

  nativeBuildInputs = [ qmake ];
  buildInputs = [ qtbase libGLU ]
    ++ lib.optional stdenv.hostPlatform.isDarwin AGL;

  dontWrapQtApps = true;

  postPatch = ''
    cd QGLViewer
  '';

  meta = {
    description = "C++ library based on Qt that eases the creation of OpenGL 3D viewers";
    homepage = "http://libqglviewer.com";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.all;
  };
})
