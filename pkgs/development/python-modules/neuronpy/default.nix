{ lib
, buildPythonPackage
, fetchPypi
, numpy
, matplotlib
, scipy
, isPy27
}:

buildPythonPackage rec {
  pname = "neuronpy";
  version = "0.1.6";
  disabled = !isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1clhc2b5fy2l8nfrji4dagmj9419nj6kam090yqxhq5c28sngk25";
  };

  propagatedBuildInputs = [ numpy matplotlib scipy ];

  #No tests included
  doCheck = false;

  meta = with lib; {
    description = "Interfaces and utilities for the NEURON simulator and analysis of neural data";
    maintainers = [ maintainers.nico202 ];
    license = licenses.mit;
  };

}
