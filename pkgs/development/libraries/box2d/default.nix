{ stdenv, fetchurl, unzip, cmake, libGLU_combined, freeglut, libX11, xproto, inputproto
, libXi, pkgconfig }:

stdenv.mkDerivation rec {
  name = "box2d-${version}";
  version = "2.3.0";

  src = fetchurl {
    url = "https://github.com/erincatto/Box2D/archive/v${version}.tar.gz";
    sha256 = "1dmbswh4x2n5l3c9h0k72m0z4rdpzfy1xl8m8p3rf5rwkvk3bkg2";
  };

  sourceRoot = "Box2D-${version}/Box2D";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    unzip cmake libGLU_combined freeglut libX11 xproto inputproto libXi
  ];

  cmakeFlags = [ "-DBOX2D_INSTALL=ON" "-DBOX2D_BUILD_SHARED=ON" ];

  prePatch = ''
    substituteInPlace Box2D/Common/b2Settings.h \
      --replace 'b2_maxPolygonVertices	8' 'b2_maxPolygonVertices	15'
  '';

  meta = with stdenv.lib; {
    description = "2D physics engine";
    homepage = http://box2d.org/;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
    license = licenses.zlib;
  };
}
