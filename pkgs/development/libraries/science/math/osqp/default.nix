{ lib, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "osqp";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "oxfordcontrol";
    repo = "osqp";
    rev = "v${version}";
    sha256 = "sha256-enkK5EFyAeLaUnHNYS3oq43HsHY5IuSLgsYP0k/GW8c=";
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
