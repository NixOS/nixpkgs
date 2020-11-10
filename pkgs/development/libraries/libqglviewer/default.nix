{ stdenv, fetchurl, qmake, qtbase, libGLU, AGL }:

stdenv.mkDerivation rec {
  pname = "libqglviewer";
  version = "2.7.2";

  src = fetchurl {
    url = "http://www.libqglviewer.com/src/libQGLViewer-${version}.tar.gz";
    sha256 = "023w7da1fyn2z69nbkp2rndiv886zahmc5cmira79zswxjfpklp2";
  };

  nativeBuildInputs = [ qmake ];
  buildInputs = [ qtbase libGLU ]
    ++ stdenv.lib.optional stdenv.isDarwin AGL;

  postPatch = ''
    cd QGLViewer
  '';

  meta = with stdenv.lib; {
    description = "C++ library based on Qt that eases the creation of OpenGL 3D viewers";
    homepage = "http://libqglviewer.com";
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
