{ lib, stdenv, fetchFromGitHub, cmake, libGLU, libGL, freeglut, libX11, xorgproto
, libXi, pkg-config }:

stdenv.mkDerivation rec {
  pname = "box2d";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "erincatto";
    repo = "box2d";
    rev = "v${version}";
    sha256 = "sha256-Z2J17YMzQNZqABIa5eyJDT7BWfXveymzs+DWsrklPIs=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ libGLU libGL freeglut libX11 xorgproto libXi ];

  cmakeFlags = [
    "-DBOX2D_INSTALL=ON"
    "-DBOX2D_BUILD_SHARED=ON"
    "-DBOX2D_BUILD_EXAMPLES=OFF"
  ];

  prePatch = ''
    cd Box2D
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
