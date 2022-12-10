{ lib, stdenv, fetchFromGitHub, cmake, pkg-config }:

stdenv.mkDerivation rec {
  pname = "libebml";
  version = "1.4.4";

  src = fetchFromGitHub {
    owner  = "Matroska-Org";
    repo   = "libebml";
    rev    = "release-${version}";
    sha256 = "sha256-36SfZUHJ2sIvrrHox583cQqfWWcrL2zW1IHzgDchC9g=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=YES"
    "-DCMAKE_INSTALL_PREFIX="
  ];

  meta = with lib; {
    description = "Extensible Binary Meta Language library";
    homepage = "https://dl.matroska.org/downloads/libebml/";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ spwhitt ];
    platforms = platforms.unix;
  };
}
