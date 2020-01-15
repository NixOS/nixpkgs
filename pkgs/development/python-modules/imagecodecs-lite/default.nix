{ lib, fetchPypi, buildPythonPackage
, pytest
, numpy
, cython
}:

buildPythonPackage rec {
  pname = "imagecodecs-lite";
  version = "2019.4.20";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1cp88g7g91gdhjhaz6gvb4jzvi5ad817id9f2bnc5r95ag93bqb0";
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
