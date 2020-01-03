{ lib, fetchPypi, buildPythonPackage, numpy
}:

buildPythonPackage rec {
  pname = "plyfile";
  version = "0.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b119705dec157314cf504e9d2d6f7d5a76606495a778b673c2864ac92895dced";
  };

  propagatedBuildInputs = [ numpy ];

  meta = with lib; {
    description = "NumPy-based text/binary PLY file reader/writer for Python";
    homepage    = https://github.com/dranjan/python-plyfile;
    maintainers = with maintainers; [ abbradar ];
  };

}
