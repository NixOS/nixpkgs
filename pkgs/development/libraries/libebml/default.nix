{ lib, stdenv, fetchFromGitHub, cmake, pkg-config }:

stdenv.mkDerivation rec {
  pname = "libebml";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner  = "Matroska-Org";
    repo   = "libebml";
    rev    = "release-${version}";
    sha256 = "04bn1i7g4vwmkv3hv26rmcb59zkl2rh37qnfjm52j560bjlyd7im";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=YES"
  ];

  meta = with lib; {
    description = "Extensible Binary Meta Language library";
    homepage = "https://dl.matroska.org/downloads/libebml/";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ spwhitt ];
    platforms = platforms.unix;
  };
}
