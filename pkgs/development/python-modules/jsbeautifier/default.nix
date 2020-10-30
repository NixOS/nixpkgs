{ lib, fetchPypi, buildPythonApplication, editorconfig, pytest, six }:

buildPythonApplication rec {
  pname = "jsbeautifier";
  version = "1.13.0";

  propagatedBuildInputs = [ six editorconfig ];
  checkInputs = [ pytest ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "f5565fbcd95f79945e124324815e586ae0d2e43df5af82a4400390e6ea789e8b";
  };

  meta = with lib; {
    homepage    = "http://jsbeautifier.org";
    description = "JavaScript unobfuscator and beautifier.";
    license     = licenses.mit;
    maintainers = with maintainers; [ apeyroux ];
  };
}
