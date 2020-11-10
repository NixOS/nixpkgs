{ stdenv
, buildPythonPackage
, fetchPypi
, lxml
, pytest
}:

buildPythonPackage rec {
  version = "1.0.1";
  pname = "et_xmlfile";

  src = fetchPypi {
    inherit pname version;
    sha256="0nrkhcb6jdrlb6pwkvd4rycw34y3s931hjf409ij9xkjsli9fkb1";
  };

  checkInputs = [ lxml pytest ];
  checkPhase = ''
    py.test $out
  '';

  meta = with stdenv.lib; {
    description = "An implementation of lxml.xmlfile for the standard library";
    longDescription = ''
      et_xmlfile is a low memory library for creating large XML files.

      It is based upon the xmlfile module from lxml with the aim of
      allowing code to be developed that will work with both
      libraries. It was developed initially for the openpyxl project
      but is now a standalone module.

      The code was written by Elias Rabel as part of the Python
      Düsseldorf openpyxl sprint in September 2014.
    '';
    homepage = "https://pypi.python.org/pypi/et_xmlfile";
    license = licenses.mit;
    maintainers = with maintainers; [ sjourdois ];
  };

}
