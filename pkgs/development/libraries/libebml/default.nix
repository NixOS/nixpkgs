{ stdenv, fetchFromGitHub, cmake, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "libebml";
  version = "1.3.9";

  src = fetchFromGitHub {
    owner  = "Matroska-Org";
    repo   = "libebml";
    rev    = "release-${version}";
    sha256 = "0q2xfabaymrf0xkhwc9akx6m04lgra2b53wcn9mnh5dqiiazizi7";
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
