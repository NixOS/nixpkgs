{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "commandparse";
  version = "1.1.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-S9e90BtS6qMjFtYUmgC0w4IKQP8q1iR2tGqq5l2+n6o=";
  };

  # tests only distributed upstream source, not PyPi
  doCheck = false;

  pythonImportsCheck = [ "commandparse" ];

  meta = {
    description = "Python module to parse command based CLI application";
    homepage = "https://github.com/flgy/commandparse";
    license = with lib.licenses; [ mit ];
    maintainers = [ lib.maintainers.fab ];
  };
}
