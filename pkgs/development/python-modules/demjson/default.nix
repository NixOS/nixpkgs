{ lib, python, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "demjson";
  version = "2.2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ygbddpnvp5lby6mr5kz60la3hkvwwzv3wwb3z0w9ngxl0w21pii";
  };

  checkPhase = lib.optionalString isPy3k ''
    ${python.interpreter} -m lib2to3 -w test/test_demjson.py
  '' + ''
    ${python.interpreter} test/test_demjson.py
  '';

  meta = with lib; {
    description = "Encoder/decoder and lint/validator for JSON (JavaScript Object Notation)";
    homepage = "https://github.com/dmeranda/demjson";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ bjornfor ];
    platforms = platforms.all;
  };
}
