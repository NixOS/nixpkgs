{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, numpy
, pandas
, progressbar2
, scipy
, future
, pytest
}:

buildPythonPackage rec {
  pname = "pygam";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rli8w0fgfr6mxk5cx3n6i5zafi1j0abl2nslrrdxzmjm2p03bjw";
  };

  # NOTE: future is listed in install_requires, even for Python 3
  propagatedBuildInputs = [ numpy pandas progressbar2 scipy future ];
  checkInputs = [ pytest ];
  checkPhase = ''
    cd pygam/tests
    pytest
  '';

  meta = with lib; {
    description = "A Python implementation of Generalized Additive Models";
    homepage = "https://github.com/dswah/pyGAM";
    license = licenses.asl20;
  };
}
