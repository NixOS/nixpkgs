{ buildPythonPackage, fetchFromGitHub, lib, numpy, scipy, future, cmake }:

buildPythonPackage rec {
  pname = "osqp-python";
  version = "2.0a1";

  nativeBuildInputs = [ cmake ];
  dontUseCmakeConfigure = true;

  propagatedBuildInputs = [ numpy future scipy ];

  src = fetchFromGitHub {
    owner = "oxfordcontrol";
    repo = "osqp-python";
    rev = "v0.5.0";
    fetchSubmodules = true;
    sha256 = "1x65mmm9sq189ncgm1fha245krk2y7aq0gw3g1fld0z36zrs9ynz";
  };

  meta = {
    description = "Python interface for OSQP";
    homepage = https://osqp.org;
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.teh ];
  };
}
