{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  version = "2.0.6";
  pname = "pydispatcher";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-PX5PQ8cAAKHcox+SaU6Z0BAZNPpuq11UVadYhY2G35U=";
  };

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    homepage = "http://pydispatcher.sourceforge.net/";
    description = "Signal-registration and routing infrastructure for use in multiple contexts";
    license = licenses.bsd3;
  };

}
