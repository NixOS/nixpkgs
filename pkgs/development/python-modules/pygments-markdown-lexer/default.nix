{
  lib,
  buildPythonPackage,
  fetchPypi,
  pygments,
}:

buildPythonPackage rec {
  pname = "pygments-markdown-lexer";
  version = "0.1.0.dev39";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-TBKMJkULWIZSHGdNdZ+V/DdouJVafZyBhm7gITwv698=";
  };

  propagatedBuildInputs = [ pygments ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/jhermann/pygments-markdown-lexer";
    description = "Pygments Markdown Lexer – A Markdown lexer for Pygments to highlight Markdown code snippets";
    license = licenses.asl20;
  };
}
