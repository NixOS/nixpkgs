{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "commandparse";
  version = "1.1.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-S9e90BtS6qMjFtYUmgC0w4IKQP8q1iR2tGqq5l2+n6o=";
  };

  # tests only distributed upstream source, not PyPi
  doCheck = false;

  pythonImportsCheck = [ "commandparse" ];

  meta = with lib; {
    description = "Python module to parse command based CLI application";
    homepage = "https://github.com/flgy/commandparse";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.fab ];
  };
}
