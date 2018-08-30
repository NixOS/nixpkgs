{ lib, fetchPypi, buildPythonPackage, numpy
}:

buildPythonPackage rec {
  pname = "plyfile";
  version = "0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "067e384e3723f28dbbd8e8f976a9712dadf6761b2d62c4c1a90821e3c5310bce";
  };

  propagatedBuildInputs = [ numpy ];

  meta = with lib; {
    description = "NumPy-based text/binary PLY file reader/writer for Python";
    homepage    = https://github.com/dranjan/python-plyfile;
    maintainers = with maintainers; [ abbradar ];
  };

}
