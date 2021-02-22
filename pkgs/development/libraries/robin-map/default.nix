{ lib, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "robin-map";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "Tessil";
    repo = pname;
    rev = "v${version}";
    sha256 = "1li70vwsksva9c4yly90hjafgqfixi1g6d52qq9p6r60vqc4pkjj";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://github.com/Tessil/robin-map";
    description = "C++ implementation of a fast hash map and hash set using robin hood hashing";
    license = licenses.mit;
    maintainers = with maintainers; [ goibhniu jtojnar ];
    platforms = platforms.unix;
  };
}
