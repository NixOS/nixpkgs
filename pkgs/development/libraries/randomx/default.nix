{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "randomX";
  version = "1.1.8";

  nativeBuildInputs = [ cmake ];

  src = fetchFromGitHub {
    owner = "tevador";
    repo = pname;
    rev = "v${version}";
    sha256 = "13h2cw8drq7xn3v8fbpxrlsl8zq3fs8gd2pc1pv28ahr9qqjz1gc";
  };

  meta = with stdenv.lib; {
    description = "Proof of work algorithm based on random code execution";
    homepage = "https://github.com/tevador/RandomX";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rnhmjoj ];
    platforms = platforms.unix;
  };

}
