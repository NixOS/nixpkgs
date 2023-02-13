{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, python
}:

buildPythonPackage rec {
  pname = "demjson3";
  version = "3.0.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-N8g7DG6wjSXe/IjfCipIddWKeAmpZQvW7uev2AU826w=";
  };

  checkPhase = ''
    ${python.interpreter} test/test_demjson3.py
  '';

  pythonImportsCheck = [
    "demjson3"
  ];

  meta = with lib; {
    description = "Encoder/decoder and lint/validator for JSON (JavaScript Object Notation)";
    homepage = "https://github.com/nielstron/demjson3/";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ fab ];
  };
}
