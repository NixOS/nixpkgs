{ lib, stdenv, fetchFromGitLab, cmake }:

stdenv.mkDerivation rec {
  pname = "olm";
  version = "3.2.6";

  src = fetchFromGitLab {
    domain = "gitlab.matrix.org";
    owner = "matrix-org";
    repo = pname;
    rev = version;
    sha256 = "1srmw36nxi0z2y5d9adks09p950qm0fscbnrq1fl37fdypvjl1sk";
  };

  nativeBuildInputs = [ cmake ];

  doCheck = true;

  meta = with lib; {
    description = "Implements double cryptographic ratchet and Megolm ratchet";
    homepage = "https://gitlab.matrix.org/matrix-org/olm";
    license = licenses.asl20;
    maintainers = with maintainers; [ tilpner oxzi ];
  };
}
