{ lib, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "osqp";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "oxfordcontrol";
    repo = "osqp";
    rev = "v${version}";
    sha256 = "1gwk1bqsk0rd85zf7xplbwq822y5pnxjmqc14jj6knqbab9afvrs";
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
