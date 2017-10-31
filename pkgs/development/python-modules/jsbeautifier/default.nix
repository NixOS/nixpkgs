{ stdenv, fetchurl, buildPythonApplication, EditorConfig, pytest, six }:

buildPythonApplication rec {
  pname = "jsbeautifier";
  version = "1.7.4";
  name = "jsbeautifier-1.6.14";

  propagatedBuildInputs = [ six ];

  buildInputs = [ EditorConfig pytest ];

  src = fetchurl {
    url = "mirror://pypi/j/jsbeautifier/${name}.tar.gz";
    sha256 = "7fc14f279117a55a5e854602f6e8c1cb178c6d83f7cf75e2e9f50678fe11079e";
  };

  meta = with stdenv.lib; {
    homepage    = "http://jsbeautifier.org";
    description = "JavaScript unobfuscator and beautifier.";
    license     = licenses.mit;
    maintainers = with maintainers; [ apeyroux ];
  };
}
