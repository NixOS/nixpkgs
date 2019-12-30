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
    sha256 = "95d18aa13ceb1b18a6109433b42d054e13b9a295cba96c08ab719f864f589d68";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ numpy cython ];

  meta = with lib; {
    description = "Block-oriented, in-memory buffer transformation, compression, and decompression functions";
    homepage = "https://www.lfd.uci.edu/~gohlke/";
    maintainers = [ maintainers.tbenst ];
    license = licenses.bsd3;
  };
}
