{ lib
, buildPythonPackage
, fetchPypi
, pygments
}:

buildPythonPackage rec {
  pname = "pygments-markdown-lexer";
  version = "0.1.0.dev39";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "1pzb5wy23q3fhs0rqzasjnw6hdzwjngpakb73i98cn0b8lk8q4jc";
  };

  propagatedBuildInputs = [ pygments ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/jhermann/pygments-markdown-lexer";
    description = "Pygments Markdown Lexer – A Markdown lexer for Pygments to highlight Markdown code snippets";
    license = licenses.asl20;
  };

}
