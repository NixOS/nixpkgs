{ lib, stdenv, fetchurl, unzip, cmake, libGLU, libGL, freeglut, libX11, xorgproto
, libXi, pkg-config }:

stdenv.mkDerivation rec {
  pname = "box2d";
  version = "2.3.1";

  src = fetchurl {
    url = "https://github.com/erincatto/box2d/archive/v${version}.tar.gz";
    sha256 = "0p03ngsmyz0r5kbpiaq10ns4fxwkjvvawi8k6pfall46b93wizsq";
  };

  sourceRoot = "box2d-${version}/Box2D";

  nativeBuildInputs = [ cmake unzip pkg-config ];
  buildInputs = [ libGLU libGL freeglut libX11 xorgproto libXi ];

  cmakeFlags = [
    "-DBOX2D_INSTALL=ON"
    "-DBOX2D_BUILD_SHARED=ON"
    "-DBOX2D_BUILD_EXAMPLES=OFF"
  ];

  prePatch = ''
    substituteInPlace Box2D/Common/b2Settings.h \
      --replace 'b2_maxPolygonVertices	8' 'b2_maxPolygonVertices	15'
  '';

  meta = with lib; {
    description = "2D physics engine";
    homepage = "https://box2d.org/";
    maintainers = [ maintainers.raskin ];
    platforms = platforms.unix;
    license = licenses.zlib;
  };
}
