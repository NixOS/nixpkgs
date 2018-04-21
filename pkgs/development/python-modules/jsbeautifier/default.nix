{ stdenv, fetchurl, buildPythonApplication, EditorConfig, pytest, six }:

buildPythonApplication rec {
  pname = "jsbeautifier";
  version = "1.7.5";
  name = "${pname}-${version}";

  propagatedBuildInputs = [ six ];

  buildInputs = [ EditorConfig pytest ];

  src = fetchurl {
    url = "mirror://pypi/j/jsbeautifier/${name}.tar.gz";
    sha256 = "78eb1e5c8535484f0d0b588aca38da3fb5e0e34de2d1ab53c077e71c55757473";
  };

  meta = with stdenv.lib; {
    homepage    = "http://jsbeautifier.org";
    description = "JavaScript unobfuscator and beautifier.";
    license     = licenses.mit;
    maintainers = with maintainers; [ apeyroux ];
  };
}
