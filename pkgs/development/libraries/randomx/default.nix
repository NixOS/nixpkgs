{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "randomX";
  version = "1.1.7";

  nativeBuildInputs = [ cmake ];

  src = fetchFromGitHub {
    owner = "tevador";
    repo = pname;
    rev = "v${version}";
    sha256 = "1d42dw4zrd7mzfqs6gwk27jj6lsh6pwv85p1ckx9dxy8mw3m52ah";
  };

  meta = with stdenv.lib; {
    description = "Proof of work algorithm based on random code execution";
    homepage = https://github.com/tevador/RandomX;
    license = licenses.bsd3;
    maintainers = with maintainers; [ rnhmjoj ];
    platforms = platforms.unix;
  };

}
