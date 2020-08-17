{ stdenv, fetchFromGitHub, cmake, pkgconfig
, libebml }:

stdenv.mkDerivation rec {
  pname = "libmatroska";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner  = "Matroska-Org";
    repo   = "libmatroska";
    rev    = "release-${version}";
    sha256 = "1ws07ldcm5gy8z8p627vknqcb8iw1hxdby24g0xi6hbfy66p6qxs";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ libebml ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=YES"
  ];

  meta = with stdenv.lib; {
    description = "A library to parse Matroska files";
    homepage = "https://matroska.org/";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ spwhitt ];
    platforms = platforms.unix;
  };
}
