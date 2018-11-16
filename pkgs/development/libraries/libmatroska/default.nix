{ stdenv, fetchFromGitHub, cmake, pkgconfig
, libebml }:

stdenv.mkDerivation rec {
  name = "libmatroska-${version}";
  version = "1.4.9";

  src = fetchFromGitHub {
    owner  = "Matroska-Org";
    repo   = "libmatroska";
    rev    = "release-${version}";
    sha256 = "1hfrcpvmyqnvdkw8rz1z20zw7fpnjyl5h0g9ky7k6y1a44b1fz86";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ libebml ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=YES"
  ];

  meta = with stdenv.lib; {
    description = "A library to parse Matroska files";
    homepage = https://matroska.org/;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ spwhitt ];
    platforms = platforms.unix;
  };
}
