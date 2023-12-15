{ lib, fetchPypi, buildPythonPackage, numpy
}:

buildPythonPackage rec {
  pname = "plyfile";
  version = "1.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-TOrt8e2Ss6Jrdm/IxWzaG5sjkOwpmxbe3i5f1FCXJho=";
  };

  propagatedBuildInputs = [ numpy ];

  meta = with lib; {
    description = "NumPy-based text/binary PLY file reader/writer for Python";
    homepage    = "https://github.com/dranjan/python-plyfile";
    maintainers = with maintainers; [ abbradar ];
  };

}
