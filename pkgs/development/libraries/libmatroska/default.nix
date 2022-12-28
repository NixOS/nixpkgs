{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, libebml }:

stdenv.mkDerivation rec {
  pname = "libmatroska";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner  = "Matroska-Org";
    repo   = "libmatroska";
    rev    = "release-${version}";
    sha256 = "sha256-hfu3Q1lIyMlWFWUM2Pu70Hie0rlQmua7Kq8kSIWnfHE=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ libebml ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=YES"
    "-DCMAKE_INSTALL_PREFIX="
  ];

  meta = with lib; {
    description = "A library to parse Matroska files";
    homepage = "https://matroska.org/";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ spwhitt ];
    platforms = platforms.unix;
  };
}
