{ lib, buildPythonPackage, fetchPypi, six, pytest }:

buildPythonPackage rec {
  pname = "allpairspy";
  version = "2.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9fb7962ee523bd96c5098cd3c97ac1b8eb73021d3df9314657ee9de00f52e034";
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
