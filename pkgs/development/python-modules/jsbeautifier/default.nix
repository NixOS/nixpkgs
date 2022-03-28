{ lib, fetchPypi, buildPythonApplication, editorconfig, pytest, six }:

buildPythonApplication rec {
  pname = "jsbeautifier";
  version = "1.14.1";

  propagatedBuildInputs = [ six editorconfig ];
  checkInputs = [ pytest ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ZfT3dLDkywIutJmbRc1ndi92Qnxe80CCq6VLwdjvI+s=";
  };

  meta = with lib; {
    homepage    = "http://jsbeautifier.org";
    description = "JavaScript unobfuscator and beautifier.";
    license     = licenses.mit;
    maintainers = with maintainers; [ apeyroux ];
  };
}
