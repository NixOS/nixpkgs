{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "python-mimeparse";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "76e4b03d700a641fd7761d3cd4fdbbdcd787eade1ebfac43f877016328334f78";
  };

  # error: invalid command 'test'
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A module provides basic functions for parsing mime-type names and matching them against a list of media-ranges";
    homepage = "https://github.com/dbtsai/python-mimeparse";
    license = licenses.mit;
  };

}
