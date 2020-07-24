{ stdenv, fetchFromGitHub, cmake, pkgconfig
, libebml }:

stdenv.mkDerivation rec {
  pname = "libmatroska";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner  = "Matroska-Org";
    repo   = "libmatroska";
    rev    = "release-${version}";
    sha256 = "118xxdgd3gkwamf59ac2c90s52pz5r0g2jmlrsj1kppybxka5f07";
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
