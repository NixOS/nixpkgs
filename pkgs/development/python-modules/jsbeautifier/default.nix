{ lib, fetchPypi, buildPythonApplication, editorconfig, pytest, six }:

buildPythonApplication rec {
  pname = "jsbeautifier";
  version = "1.12.0";

  propagatedBuildInputs = [ six editorconfig ];
  checkInputs = [ pytest ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "65dea76bf2f551d7f1686111d2794506e07b6c7c477feca2124596376feb8713";
  };

  meta = with lib; {
    homepage    = "http://jsbeautifier.org";
    description = "JavaScript unobfuscator and beautifier.";
    license     = licenses.mit;
    maintainers = with maintainers; [ apeyroux ];
  };
}
