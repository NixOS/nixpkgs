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
  version = "0.8.11";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1105d233a0956dd8dd1e710d20b159e2d72ac3c301041b95f4d4ceb3e0ebebc4";
  };

  nativeCheckInputs = [ behave mock pyparsing pytest ];
  propagatedBuildInputs = [ lxml ];

  checkPhase = ''
    py.test tests
    behave --format progress --stop --tags=-wip
  '';

  meta = {
    description = "Create and update Microsoft Word .docx files";
    homepage = "https://python-docx.readthedocs.io/en/latest/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.alexchapman ];
  };
}
