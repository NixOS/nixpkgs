{ lib
, buildPythonPackage
, fetchPypi
, dash
}:

buildPythonPackage rec {
  pname = "dash_daq";
  version = "0.3.3";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "8370e6624c2b2dd8c53ed8af9a5a376d4b4a8bb4eb4899b57ae8e55fdb8bad8f";
  };
  
  propagatedBuildInputs = [ dash ];
  
  # No tests in archive
  doCheck = false;
  
  meta = with lib; {
    description = "DAQ components for Dash";
    homepage = "http://github.com/plotly/dash-daq";
    license = licenses.mit;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
