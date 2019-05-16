{ stdenv, fetchFromGitHub, cmake, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "libebml";
  version = "1.3.7";

  src = fetchFromGitHub {
    owner  = "Matroska-Org";
    repo   = "libebml";
    rev    = "release-${version}";
    sha256 = "0pdfl83nbbdddbxajx34srg4mcfcz8ca21qyvlnpw81hfnrhmjkv";
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
