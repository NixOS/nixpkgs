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
  version = "0.8.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "117i84s6fcdsrfckbvznnqgqwhnf1x0523ps16cki8sg9byydv2m";
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
