{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "markdown2";
  version = "2.3.6";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "08a124043aa0ad36ba2136239547d5011a2b770278abb11a5609611e0040ea05";
  };

  meta = with stdenv.lib; {
    description = "A fast and complete Python implementation of Markdown";
    homepage =  https://github.com/trentm/python-markdown2;
    license = licenses.mit;
    maintainers = with maintainers; [ hbunke ];
  };
}
