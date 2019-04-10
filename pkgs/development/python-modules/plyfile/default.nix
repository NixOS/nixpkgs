{ lib, fetchPypi, buildPythonPackage, numpy
}:

buildPythonPackage rec {
  pname = "plyfile";
  version = "0.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "84ba5ee8c70a4924f64aa7edff5764b929f3b7842d53a3197d0b753818ad7089";
  };

  propagatedBuildInputs = [ numpy ];

  meta = with lib; {
    description = "NumPy-based text/binary PLY file reader/writer for Python";
    homepage    = https://github.com/dranjan/python-plyfile;
    maintainers = with maintainers; [ abbradar ];
  };

}
