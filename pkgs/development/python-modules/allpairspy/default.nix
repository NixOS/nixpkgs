{ lib, buildPythonPackage, fetchPypi, six, pytest }:

buildPythonPackage rec {
  pname = "allpairspy";
  version = "2.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9358484c91abe74ba18daf9d6d6904c5be7cc8818397d05248c9d336023c28b1";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "Pairwise test combinations generator";
    homepage = https://github.com/thombashi/allpairspy;
    license = licenses.mit;
  };
}
