{ lib, stdenv, fetchFromGitLab, cmake }:

stdenv.mkDerivation rec {
  pname = "olm";
  version = "3.2.11";

  src = fetchFromGitLab {
    domain = "gitlab.matrix.org";
    owner = "matrix-org";
    repo = pname;
    rev = version;
    sha256 = "sha256-/ozMvcHDhYruhzp8xfskKOYCbe/vS4pEOPn1+1Pb+Q0=";
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
