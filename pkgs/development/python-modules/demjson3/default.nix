{ lib
, python
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "demjson3";
  version = "3.0.5";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
     owner = "nielstron";
     repo = "demjson3";
     rev = "release-3.0.5";
     sha256 = "1zknismng6s1z1fj7shp916fwpdp9z5jfv2qn98jpkckpk8b3myq";
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
