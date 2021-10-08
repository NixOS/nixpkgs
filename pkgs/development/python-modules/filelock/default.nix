{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "filelock";
  version = "3.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8c7eab13dc442dc249e95158bcc12dec724465919bdc9831fdbf0660f03d1785";
  };

  meta = with lib; {
    homepage = "https://github.com/benediktschmitt/py-filelock";
    description = "A platform independent file lock for Python";
    license = licenses.unlicense;
    maintainers = with maintainers; [ hyphon81 ];
  };
}
