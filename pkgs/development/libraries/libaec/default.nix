{ lib, stdenv, fetchFromGitLab
, cmake
}:

stdenv.mkDerivation rec {
  pname = "libaec";
  version  = "1.0.6";

  src = fetchFromGitLab {
    domain = "gitlab.dkrz.de";
    owner = "k202009";
    repo = "libaec";
    rev = "v${version}";
    sha256 = "sha256-N0YwJuVqv8jv/uSbpn/eJBTMhlHDcY/74+anH2vNvpI=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    homepage = "https://gitlab.dkrz.de/k202009/libaec";
    description = "Adaptive Entropy Coding library";
    license = licenses.bsd2;
    maintainers = with maintainers; [ tbenst ];
  };
}
