{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "libopenaptx";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "pali";
    repo = "libopenaptx";
    rev = version;
    sha256 = "nTpw4vWgJ765FM6Es3SzaaaZr0YDydXglb0RWLbiigI=";
  };

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    # disable static builds
    "ANAME="
    "AOBJECTS="
    "STATIC_UTILITIES="
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Audio Processing Technology codec (aptX)";
    license = licenses.lgpl21Plus;
    homepage = "https://github.com/pali/libopenaptx";
    platforms = platforms.linux;
    maintainers = with maintainers; [ orivej ];
  };
}
