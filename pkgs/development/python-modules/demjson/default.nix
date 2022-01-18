{ lib
, python
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "demjson";
  version = "2.2.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ygbddpnvp5lby6mr5kz60la3hkvwwzv3wwb3z0w9ngxl0w21pii";
  };

  doCheck = !(isPy3k);

  checkPhase = ''
    ${python.interpreter} test/test_demjson.py
  '';

  pythonImportsCheck = [
    "demjson"
  ];

  meta = with lib; {
    description = "Encoder/decoder and lint/validator for JSON (JavaScript Object Notation)";
    homepage = "https://github.com/dmeranda/demjson";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ bjornfor ];
  };
}
