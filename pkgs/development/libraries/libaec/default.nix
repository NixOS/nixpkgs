{ lib, stdenv, fetchFromGitLab
, cmake
}:

stdenv.mkDerivation rec {
  pname = "libaec";
  version  = "1.1.1";

  src = fetchFromGitLab {
    domain = "gitlab.dkrz.de";
    owner = "k202009";
    repo = "libaec";
    rev = "v${version}";
    sha256 = "sha256-5nsJrbJVqjXNb3exYgEvSGUq8ccy9HG+gwmBZvjnupc=";
  };

  nativeBuildInputs = [
    cmake
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://gitlab.dkrz.de/k202009/libaec";
    description = "Adaptive Entropy Coding library";
    license = licenses.bsd2;
    maintainers = with maintainers; [ tbenst ];
  };
}
