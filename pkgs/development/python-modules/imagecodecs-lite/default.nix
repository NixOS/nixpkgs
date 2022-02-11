{ lib, fetchPypi, buildPythonPackage
, pytest
, numpy
, cython
}:

buildPythonPackage rec {
  pname = "imagecodecs-lite";
  version = "2019.12.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0s4xb17qd7vimc46rafbjnibj4sf0lnv8cwl22k1h6zb7jhqmlcm";
  };

  nativeBuildInputs = [
    cython
  ];

  checkInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    numpy
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Block-oriented, in-memory buffer transformation, compression, and decompression functions";
    homepage = "https://www.lfd.uci.edu/~gohlke/";
    maintainers = [ maintainers.tbenst ];
    license = licenses.bsd3;
  };
}
