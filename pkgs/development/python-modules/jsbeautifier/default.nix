{ lib, fetchPypi, buildPythonApplication, EditorConfig, fetchpatch, pytest, six }:

buildPythonApplication rec {
  pname = "jsbeautifier";
  version = "1.10.0";

  propagatedBuildInputs = [ six EditorConfig ];
  checkInputs = [ pytest ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "1e389572ade865173605471e98df4002f4b6e5235121c13f1e4497a3eac69108";
  };

  meta = with lib; {
    homepage    = "http://jsbeautifier.org";
    description = "JavaScript unobfuscator and beautifier.";
    license     = licenses.mit;
    maintainers = with maintainers; [ apeyroux ];
  };
}
