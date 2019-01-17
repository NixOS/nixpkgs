{ lib, fetchPypi, buildPythonApplication, EditorConfig, pytest, six }:

buildPythonApplication rec {
  pname = "jsbeautifier";
  version = "1.8.9";

  propagatedBuildInputs = [ six ];

  buildInputs = [ EditorConfig pytest ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "7d02baa9b0459bf9c5407c1b99ad5566de04a3b664b18a58ac64f52832034204";
  };

  meta = with lib; {
    homepage    = "http://jsbeautifier.org";
    description = "JavaScript unobfuscator and beautifier.";
    license     = licenses.mit;
    maintainers = with maintainers; [ apeyroux ];
  };
}
