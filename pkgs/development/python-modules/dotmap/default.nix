{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dotmap";
  version = "1.3.25";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-wOJjGlMUjTYj2af8I8dg1LfehCL2u4gYuEfkYHKrTPA=";
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
