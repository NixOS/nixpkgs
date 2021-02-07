{ lib
, stdenv
, cmake
, darwin
, freeglut
, freetype
, libGL
, libGLU
, libjpeg
, libpng
, libtiff
, libXft
, libXi
, xlibsWrapper
, xorgproto
, zlib

, version
, src
}:

stdenv.mkDerivation {
  pname = "fltk";
  inherit version src;

  patches = lib.optionals stdenv.isDarwin [ ./nsosv.patch ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    libGL
    libGLU
    libjpeg
    libpng
    libXft
    zlib
  ] ++ lib.optional stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    AGL
    Cocoa
    GLUT
  ]);

  propagatedBuildInputs = [
    xorgproto
  ] ++ lib.optional stdenv.isDarwin [
    freetype
    libtiff
  ] ++ lib.optional (!stdenv.isDarwin) [
    freeglut
    libXi
    xlibsWrapper
  ];

  cmakeFlags = [
    "-DOPTION_BUILD_SHARED_LIBS=1"
    "-DOpenGL_GL_PREFERENCE=GLVND"
  ];

  meta = with lib; {
    description = "A C++ cross-platform lightweight GUI library";
    homepage = "https://www.fltk.org";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.lgpl2Only;
  };
}
