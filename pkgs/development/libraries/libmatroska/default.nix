{ stdenv, fetchFromGitHub, cmake, pkgconfig
, libebml }:

stdenv.mkDerivation rec {
  pname = "libmatroska";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner  = "Matroska-Org";
    repo   = "libmatroska";
    rev    = "release-${version}";
    sha256 = "0yhr9hhgljva1fx3b0r4s3wkkypdfgsysbl35a4g3krkbhaa9rsd";
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
