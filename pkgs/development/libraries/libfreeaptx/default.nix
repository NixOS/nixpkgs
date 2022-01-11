{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "libfreeaptx";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "iamthehorker";
    repo = pname;
    rev = version;
    sha256 = "sha256-eEUhOrKqb2hHWanY+knpY9FBEnjkkFTB+x6BZgMBpbo=";
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
    description = "Free Implementation of Audio Processing Technology codec (aptX)";
    license = licenses.lgpl21Plus;
    homepage = "https://github.com/iamthehorker/libfreeaptx";
    platforms = platforms.linux;
    maintainers = with maintainers; [ kranzes ];
  };
}
