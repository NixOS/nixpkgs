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
    sha256 = "bc76ecac6b2d00ce6442a69d03a6f35c71cd72293cd8405a7472dfe317920024";
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
