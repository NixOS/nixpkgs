{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "randomX";
  version = "1.1.9";

  nativeBuildInputs = [ cmake ];

  src = fetchFromGitHub {
    owner = "tevador";
    repo = pname;
    rev = "v${version}";
    sha256 = "188fh4l8wda1y9vxa9asbk8nw35gyapw7gyn4w2p2qspdjhi5mnq";
  };

  meta = with lib; {
    description = "Proof of work algorithm based on random code execution";
    homepage = "https://github.com/tevador/RandomX";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rnhmjoj ];
    platforms = platforms.unix;
  };

}
