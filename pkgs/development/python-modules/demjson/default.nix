{ lib, python, buildPythonPackage, fetchFromGitHub, isPy3k }:

buildPythonPackage rec {
  pname = "demjson";
  version = "2.2.4";

  src = fetchFromGitHub {
     owner = "dmeranda";
     repo = "demjson";
     rev = "release-2.2.4";
     sha256 = "08af460dw1awn3ywdpgk34ghqfz6afsxv1mr1m5hak9q4x6jpqlc";
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
