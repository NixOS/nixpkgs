{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation {
  pname = "libstemmer";
  version = "unstable-2017-03-02";

  src = fetchFromGitHub {
    owner = "zvelo";
    repo = "libstemmer";
    rev = "78c149a3a6f262a35c7f7351d3f77b725fc646cf";
    sha256 = "06md6n6h1f2zvnjrpfrq7ng46l1x12c14cacbrzmh5n0j98crpq7";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Snowball Stemming Algorithms";
    homepage = "http://snowball.tartarus.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.all;
  };
}
