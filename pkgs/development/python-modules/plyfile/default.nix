{ lib, fetchPypi, buildPythonPackage, numpy
}:

buildPythonPackage rec {
  pname = "plyfile";
  version = "0.7.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5ac55b685cfcb3e8f70f3c5c2660bd1f6431a892a5319a612792b1ec09aec0f0";
  };

  propagatedBuildInputs = [ numpy ];

  meta = with lib; {
    description = "NumPy-based text/binary PLY file reader/writer for Python";
    homepage    = "https://github.com/dranjan/python-plyfile";
    maintainers = with maintainers; [ abbradar ];
  };

}
