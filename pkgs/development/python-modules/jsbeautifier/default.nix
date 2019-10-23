{ lib, fetchPypi, buildPythonApplication, editorconfig, pytest, six }:

buildPythonApplication rec {
  pname = "jsbeautifier";
  version = "1.10.2";

  propagatedBuildInputs = [ six editorconfig ];
  checkInputs = [ pytest ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "a5ce5195c0b54a68eb813649829143373823ca28caa4d7aa682442b87ebea1ce";
  };

  meta = with lib; {
    homepage    = "http://jsbeautifier.org";
    description = "JavaScript unobfuscator and beautifier.";
    license     = licenses.mit;
    maintainers = with maintainers; [ apeyroux ];
  };
}
