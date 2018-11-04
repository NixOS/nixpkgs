{ lib, fetchPypi, buildPythonApplication, EditorConfig, pytest, six }:

buildPythonApplication rec {
  pname = "jsbeautifier";
  version = "1.8.8";

  propagatedBuildInputs = [ six ];

  buildInputs = [ EditorConfig pytest ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "98a29abef991f9f8f8fa67c32ccc07bee3d95ef7c8323e3560f6a5e83db7412a";
  };

  meta = with lib; {
    homepage    = "http://jsbeautifier.org";
    description = "JavaScript unobfuscator and beautifier.";
    license     = licenses.mit;
    maintainers = with maintainers; [ apeyroux ];
  };
}
