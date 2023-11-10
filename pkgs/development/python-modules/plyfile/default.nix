{ lib, fetchPypi, buildPythonPackage, numpy, pdm-pep517
}:

buildPythonPackage rec {
  pname = "plyfile";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-TOrt8e2Ss6Jrdm/IxWzaG5sjkOwpmxbe3i5f1FCXJho=";
  };

  propagatedBuildInputs = [ numpy ];
  buildInputs = [ pdm-pep517 ];
  pyproject = true;

  meta = with lib; {
    description = "NumPy-based text/binary PLY file reader/writer for Python";
    homepage    = "https://github.com/dranjan/python-plyfile";
    maintainers = with maintainers; [ abbradar ];
  };

}
