{ lib
, python
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "demjson3";
  version = "3.0.5";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "103dc4pzwg8791q3zll1vv4gcc17d9v3jvr9zj23cpv9hpfsp6mb";
  };

  checkPhase = ''
    ${python.interpreter} test/test_demjson3.py
  '';

  pythonImportsCheck = [ "demjson3" ];

  meta = with lib; {
    description = "Encoder/decoder and lint/validator for JSON (JavaScript Object Notation)";
    homepage = "https://github.com/nielstron/demjson3/";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ fab ];
  };
}
