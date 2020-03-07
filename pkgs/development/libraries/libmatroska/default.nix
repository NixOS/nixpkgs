{ stdenv, fetchFromGitHub, cmake, pkgconfig
, libebml }:

stdenv.mkDerivation rec {
  pname = "libmatroska";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner  = "Matroska-Org";
    repo   = "libmatroska";
    rev    = "release-${version}";
    sha256 = "057iib6p62x31g1ikdjsjzmqzjlajqx6p74h7y4r524pzgb27fzy";
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
