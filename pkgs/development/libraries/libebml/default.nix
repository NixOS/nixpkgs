{ stdenv, fetchFromGitHub, cmake, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "libebml";
  version = "1.3.10";

  src = fetchFromGitHub {
    owner  = "Matroska-Org";
    repo   = "libebml";
    rev    = "release-${version}";
    sha256 = "1vn0g4hsygrm29qvnzhrblpwjcy2x6swf799ibxv3bzpi1j0gris";
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
