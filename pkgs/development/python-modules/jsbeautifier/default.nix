{ stdenv, fetchurl, buildPythonApplication, EditorConfig, pytest, six }:

buildPythonApplication rec {
  pname = "jsbeautifier";
  version = "1.6.14";
  name = "jsbeautifier-1.6.14";

  propagatedBuildInputs = [ six ];

  buildInputs = [ EditorConfig pytest ];

  src = fetchurl {
    url = "mirror://pypi/j/jsbeautifier/${name}.tar.gz";
    sha256 = "50b2af556aa1da7283a6a92eaa699668312cb91f2ba6b78a4422b1d42af964a2";
  };

  meta = with stdenv.lib; {
    homepage    = "http://jsbeautifier.org";
    description = "JavaScript unobfuscator and beautifier.";
    license     = licenses.mit;
    maintainers = with maintainers; [ apeyroux ];
  };
}
