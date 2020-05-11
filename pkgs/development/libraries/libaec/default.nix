{ stdenv, fetchFromGitLab
, cmake
}:

stdenv.mkDerivation rec {
  pname = "libaec";
  version  = "1.0.4";

  src = fetchFromGitLab {
    domain = "gitlab.dkrz.de";
    owner = "k202009";
    repo = "libaec";
    rev = "v${version}";
    sha256 = "1rpma89i35ahbalaqz82y201syxni7jkf9892jlyyrhhrvlnm4l2";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = with stdenv.lib; {
    homepage = "https://gitlab.dkrz.de/k202009/libaec";
    description = "Adaptive Entropy Coding library";
    license = licenses.bsd2;
    maintainers = with maintainers; [ tbenst ];
  };
}
