{ stdenv, fetchFromGitHub, cmake, pkgconfig }:

stdenv.mkDerivation rec {
  name = "libebml-${version}";
  version = "1.3.6";

  src = fetchFromGitHub {
    owner  = "Matroska-Org";
    repo   = "libebml";
    rev    = "release-${version}";
    sha256 = "0fl8d35ywj9id93yp78qlxy7j81kjri957agq40r420kmwac3dzs";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=YES"
  ];

  meta = with stdenv.lib; {
    description = "Extensible Binary Meta Language library";
    homepage = https://dl.matroska.org/downloads/libebml/;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ spwhitt ];
    platforms = platforms.unix;
  };
}
