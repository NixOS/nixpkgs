{ stdenv, buildPythonPackage, fetchPypi, numpy, nose, openmp }:

buildPythonPackage rec {
  pname = "pykdtree";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "79351b79087f473f83fb27a5cd552bd1056f2dfa7acec5d4a68f35a7cbea6776";
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
