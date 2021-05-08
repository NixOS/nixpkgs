{ lib, stdenv, fetchurl, qmake, qtbase, libGLU, AGL }:

stdenv.mkDerivation rec {
  pname = "libqglviewer";
  version = "2.7.2";

  src = fetchurl {
    url = "http://www.libqglviewer.com/src/libQGLViewer-${version}.tar.gz";
    sha256 = "023w7da1fyn2z69nbkp2rndiv886zahmc5cmira79zswxjfpklp2";
  };

  nativeBuildInputs = [ qmake ];
  buildInputs = [ qtbase libGLU ]
    ++ lib.optional stdenv.isDarwin AGL;

  dontWrapQtApps = true;

  postPatch = ''
    cd QGLViewer
  '';

  meta = with lib; {
    description = "C++ library based on Qt that eases the creation of OpenGL 3D viewers";
    homepage = "http://libqglviewer.com";
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
