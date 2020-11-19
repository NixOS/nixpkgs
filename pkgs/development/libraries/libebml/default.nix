{ stdenv, fetchFromGitHub, cmake, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "libebml";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner  = "Matroska-Org";
    repo   = "libebml";
    rev    = "release-${version}";
    sha256 = "052v4mjynndj9xgfl4lmlsnx9ai0pah0kjyr5fm34l7gj8vhc5s7";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=YES"
  ];

  meta = with stdenv.lib; {
    description = "Extensible Binary Meta Language library";
    homepage = "https://dl.matroska.org/downloads/libebml/";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ spwhitt ];
    platforms = platforms.unix;
  };
}
