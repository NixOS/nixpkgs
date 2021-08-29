{ lib, buildPythonPackage, fetchPypi, pytest, future, numpy }:

buildPythonPackage rec {
  pname = "MDP";
  version = "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ac52a652ccbaed1857ff1209862f03bf9b06d093b12606fb410787da3aa65a0e";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ future numpy ];

  # Tests disabled because of missing dependencies not in nix
  doCheck = false;

  meta = with lib; {
    description = "Library for building complex data processing software by combining widely used machine learning algorithms";
    homepage = "http://mdp-toolkit.sourceforge.net";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nico202 ];
  };
}
