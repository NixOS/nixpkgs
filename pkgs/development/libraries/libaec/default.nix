{ lib, stdenv, fetchFromGitLab
, cmake
}:

stdenv.mkDerivation rec {
  pname = "libaec";
  version  = "1.0.5";

  src = fetchFromGitLab {
    domain = "gitlab.dkrz.de";
    owner = "k202009";
    repo = "libaec";
    rev = "v${version}";
    sha256 = "sha256-Vi0fCd9V/EH+PcD+e6RZK2/isR1xGX25POhm1Xen5ak=";
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
