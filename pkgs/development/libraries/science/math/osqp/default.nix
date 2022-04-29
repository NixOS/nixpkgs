{ lib, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "osqp";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "oxfordcontrol";
    repo = "osqp";
    rev = "v${version}";
    sha256 = "sha256-RYk3zuZrJXPcF27eMhdoZAio4DZ+I+nFaUEg1g/aLNk=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "A quadratic programming solver using operator splitting";
    homepage = "https://osqp.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ taktoa ];
    platforms = platforms.all;
  };
}
