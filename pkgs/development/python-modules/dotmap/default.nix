{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dotmap";
  version = "1.3.23";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hy88kzzb7zhxfr7iyvl6rhmvz02538pbna7zypaard4a88bbbka";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [ "dotmap/test.py" ];

  pythonImportsCheck = [ "dotmap" ];

  meta = with lib; {
    description = "Python for dot-access dictionaries";
    homepage = "https://github.com/drgrib/dotmap";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
