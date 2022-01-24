{ lib, fetchPypi, buildPythonPackage, numpy
}:

buildPythonPackage rec {
  pname = "plyfile";
  version = "0.7.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9e9a18d22a3158fcd74df38761d43a7facc6df75126f2ab9f4e9a5d4d2188652";
  };

  propagatedBuildInputs = [ numpy ];

  meta = with lib; {
    description = "NumPy-based text/binary PLY file reader/writer for Python";
    homepage    = "https://github.com/dranjan/python-plyfile";
    maintainers = with maintainers; [ abbradar ];
  };

}
