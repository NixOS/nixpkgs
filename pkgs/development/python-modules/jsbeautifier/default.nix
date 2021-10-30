{ lib, fetchPypi, buildPythonApplication, editorconfig, pytest, six }:

buildPythonApplication rec {
  pname = "jsbeautifier";
  version = "1.14.0";

  propagatedBuildInputs = [ six editorconfig ];
  checkInputs = [ pytest ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "84fdb008d8af89619269a6aca702288b48f837a99427a0f529aa57ecfb36ee3c";
  };

  meta = with lib; {
    homepage    = "http://jsbeautifier.org";
    description = "JavaScript unobfuscator and beautifier.";
    license     = licenses.mit;
    maintainers = with maintainers; [ apeyroux ];
  };
}
