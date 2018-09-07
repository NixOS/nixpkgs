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
  version = "0.8.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ba9f2a7ca391b78ab385d796b38af3f21bab23c727fc8e0c5e630448d1a11fe3";
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
