{ stdenv, buildPythonPackage, fetchPypi, numpy, nose, openmp }:

buildPythonPackage rec {
  pname = "pykdtree";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0d49d3bbfa0366dbe29176754ec86df75114a25525b530dcbbb75d3ac4c263e9";
  };

  buildInputs = [ openmp ];

  propagatedBuildInputs = [ numpy ];

  checkInputs = [ nose ];

  meta = with stdenv.lib; {
    description = "kd-tree implementation for fast nearest neighbour search in Python";
    homepage = https://github.com/storpipfugl/pykdtree;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ psyanticy ];
  };
}
