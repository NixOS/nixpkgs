{ lib, stdenv, fetchFromGitLab, cmake }:

stdenv.mkDerivation rec {
  pname = "olm";
  version = "3.2.2";

  src = fetchFromGitLab {
    domain = "gitlab.matrix.org";
    owner = "matrix-org";
    repo = pname;
    rev = version;
    sha256 = "0qji25wiwmkxyfpraxj96c54hyayqmjkvwh0gsy5gb5pz5bp4mcy";
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
