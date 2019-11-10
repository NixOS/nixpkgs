{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "randomX";
  version = "1.1.6";

  nativeBuildInputs = [ cmake ];

  src = fetchFromGitHub {
    owner = "tevador";
    repo = pname;
    rev = "v${version}";
    sha256 = "1qd0rbzgxdy87wwy0n6ca29bcq25j5ndnfgmx8iyf225m4rcwngf";
  };

  meta = with stdenv.lib; {
    description = "Proof of work algorithm based on random code execution";
    homepage = https://github.com/tevador/RandomX;
    license = licenses.bsd3;
    maintainers = with maintainers; [ rnhmjoj ];
    platforms = platforms.unix;
  };

}
