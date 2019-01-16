{ lib
, behave
, buildPythonPackage
, fetchPypi
, lxml
, pytest
, pyparsing
, mock
}:

buildPythonPackage rec {
  pname = "python-docx";
  version = "0.8.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0900j8by7pvjfid41n1w55rcswawyfk077d689jcw01ddfnfqxmw";
  };

  checkInputs = [ behave mock pyparsing pytest ];
  propagatedBuildInputs = [ lxml ];

  checkPhase = ''
    py.test tests
  '';

  meta = {
    description = "Create and update Microsoft Word .docx files";
    homepage = https://python-docx.readthedocs.io/en/latest/;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.alexchapman ];
  };
}
