{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "python-mimeparse";
  version = "0.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1hyxg09kaj02ri0rmwjqi86wk4nd1akvv7n0dx77azz76wga4s9w";
  };

  # error: invalid command 'test'
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A module provides basic functions for parsing mime-type names and matching them against a list of media-ranges";
    homepage = https://code.google.com/p/mimeparse/;
    license = licenses.mit;
  };

}
