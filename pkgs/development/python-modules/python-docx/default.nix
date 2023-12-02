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
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WCm3IhQc8at5rt8MNNn+mSSyl2RYTA8hZOsrAtzfF8k=";
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
