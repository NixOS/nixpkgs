{ stdenv, fetchurl, unzip, cmake, libGLU, libGL, freeglut, libX11, xorgproto
, libXi, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "box2d";
  version = "2.3.1";

  src = fetchurl {
    url = "https://github.com/erincatto/Box2D/archive/v${version}.tar.gz";
    sha256 = "0llpcifl8zbjbpxdwz87drd01m3lwnv82xb4av6kca1xn4w2gmkm";
  };

  sourceRoot = "Box2D-${version}/Box2D";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    unzip cmake libGLU libGL freeglut libX11 xorgproto libXi
  ];

  cmakeFlags = [
    "-DBOX2D_INSTALL=ON"
    "-DBOX2D_BUILD_SHARED=ON"
    "-DBOX2D_BUILD_EXAMPLES=OFF"
  ];

  prePatch = ''
    substituteInPlace Box2D/Common/b2Settings.h \
      --replace 'b2_maxPolygonVertices	8' 'b2_maxPolygonVertices	15'
  '';

  meta = with stdenv.lib; {
    description = "2D physics engine";
    homepage = https://box2d.org/;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
    license = licenses.zlib;
  };
}
